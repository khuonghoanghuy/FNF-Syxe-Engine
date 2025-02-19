package states;

import states.debugbugbugbug.HolyShitISTHATCHARACTEREDITOR;
import backend.chart.Conductor;
import flixel.util.FlxColor;
import flixel.FlxG;
import backend.game.FunkGame;
import backend.game.FunkSprite;
import openfl.Assets;
import backend.CoolUtil;

typedef TitleData =
{
	var gfPos:Array<Float>;
	var titlePos:Array<Float>;
	var logoPos:Array<Float>;
}

class TitleState extends MusicBeatState
{
	var titleData:TitleData;

	override function create()
	{
		super.create();

		FlxG.switchState(() -> new HolyShitISTHATCHARACTEREDITOR());

		FunkGame.doTimer(1, function()
		{
			initThing();
		});
	}

	function initThing():Void
	{
		// Init modding system
		#if MOD_ALLOW
		backend.PolyHandler.reload();
		#end

		// Init JSON
		titleData = cast tjson.TJSON.parse(Assets.getText(Paths.data("titleJson.json")));

		FunkGame.doTimer(1, function()
		{
			startIntro();
		});
	}

	var dancedLeft:Bool = true;

	function startIntro():Void
	{
		Conductor.changeBPM(102);

		FunkGame.quickAddSprite({
			name: "titleText",
			x: titleData.titlePos[0],
			y: titleData.titlePos[1],
			withFrames: true,
			framesType: "sparrow",
			image: "titleEnter"
		});
		cast(FunkGame.getVariable("titleText"), FunkSprite).quickAddPrefixAnim("idle", "Press Enter to Begin", true);
		cast(FunkGame.getVariable("titleText"), FunkSprite).quickAddPrefixAnim("pressed", "ENTER PRESSED", true);
		cast(FunkGame.getVariable("titleText"), FunkSprite).playAnim("idle", true);

		FunkGame.quickAddSprite({
			name: "gfDance",
			x: titleData.gfPos[0],
			y: titleData.gfPos[1],
			withFrames: true,
			framesType: "sparrow",
			image: "gfDanceTitle"
		});
		cast(FunkGame.getVariable("gfDance"), FunkSprite).quickAddIncAnim("danceLeft", "gfDance", CoolUtil.genNumFromTo(0, 14));
		cast(FunkGame.getVariable("gfDance"), FunkSprite).quickAddIncAnim("danceRight", "gfDance", CoolUtil.genNumFromTo(15, 30));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			camera.flash(FlxColor.WHITE, 2);
			cast(FunkGame.getVariable("titleText"), FunkSprite).playAnim("pressed", true);
		}
	}

	override function beatHit()
	{
		super.beatHit();
		dancedLeft != dancedLeft;

		cast(FunkGame.getVariable("gfDance"), FunkSprite).playAnim((dancedLeft ? "danceLeft" : "danceRight"));
	}
}
