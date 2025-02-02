package;

import Conductor.BPMChangeEvent;
import flixel.addons.ui.FlxUIState;
import sys.FileSystem;

using StringTools;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	var scriptsArray:Array<HScript> = [];
	public function new() {
		super();

		var foldersToCheck:Array<String> = [];
		if (FileSystem.exists(Paths.data("scripts/global"))) {
			foldersToCheck.push(Paths.data("scripts/global"));
		} if (FileSystem.exists(Paths.data("scripts/states"))) {
			foldersToCheck.push(Paths.data("scripts/states"));
		}
		for (folder in foldersToCheck)
		{
			if (FileSystem.exists(folder) && FileSystem.isDirectory(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.hxs'))
					{
						scriptsArray.push(new HScript(folder + file));
					}
				}
			}
		}
	}

	override function create()
	{
		for (i in 0...scriptsArray.length)
			scriptsArray[i].call("onCreate", []);
		super.create();
		for (i in 0...scriptsArray.length)
			scriptsArray[i].call("onCreatePost", []);
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();
		
		for (i in 0...scriptsArray.length)
			scriptsArray[i].call("onUpdate", [elapsed]);
		super.update(elapsed);
		for (i in 0...scriptsArray.length)
			scriptsArray[i].call("onUpdatePost", [elapsed]);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
		for (i in 0...scriptsArray.length)
			scriptsArray[i].call("onStepHit", [curStep]);
	}

	public function beatHit():Void
	{
		for (i in 0...scriptsArray.length)
			scriptsArray[i].call("onBeatHit", [curBeat]);
	}
}