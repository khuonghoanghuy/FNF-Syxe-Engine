package states;

import backend.game.FunkSprite;
import flixel.FlxG;
import backend.chart.Conductor;
import backend.chart.Section;
import backend.chart.Song;

// very work in progress, will probably be temporarily scuffed
class ChartingState extends MusicBeatState
{
	override public function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		var bg:FunkSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		bg.color = 0xFF888888;
		add(bg);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
