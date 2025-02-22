package subStates;

import flixel.FlxG;

class PauseSubState extends MusicBeatSubState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.justPressed("exit"))
		{
			close();
			FlxG.switchState(() -> new states.MainMenuState());
		}
	}
}
