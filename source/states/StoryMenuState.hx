package states;

import backend.chart.Song;
import backend.game.FunkTimer;
import openfl.Assets;
import flixel.FlxG;
import sys.FileSystem;
import objects.MenuCharacter;
import objects.MenuItem;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	var weekData:Array<Dynamic> = [];
	var curWeek:Int = 0;
	var curDifficult:Int = 0;

	var grpMenuWeek:FlxTypedGroup<MenuItem>;
	var grpMenuCharacter:FlxTypedGroup<MenuCharacter>;
	var curDifficulty(default, null):Int = 0;

	override function create()
	{
		super.create();

		loadTxtWeekFile();

		grpMenuWeek = new FlxTypedGroup<MenuItem>();
		add(grpMenuWeek);

		grpMenuCharacter = new FlxTypedGroup<MenuCharacter>();
		add(grpMenuCharacter);

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, 0, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			weekThing.screenCenter(X);
			grpMenuWeek.add(weekThing);
		}
	}

	public static var hasCustomWeekImage:Bool = false;
	public static var customWeekImage:String = "week1";

	function loadTxtWeekFile():Void
	{
		var weekFolder = FileSystem.readDirectory(Paths.data("weeks"));
		for (week in weekFolder)
		{
			if (~/^week(.+)\.txt$/.match(week))
			{
				var weekData = Assets.getText(Paths.data("weeks/" + week));
				var lines:Array<String> = weekData.split("\n");
				for (line in lines)
				{
					line = StringTools.trim(line);
					if (line == "" || line.startsWith("#"))
						continue;
					if (line.indexOf("::") != -1)
					{
						var parts:Array<String> = line.split("::");
						var key:String = StringTools.trim(parts[0]);
						var value:String = StringTools.trim(parts[1]);
						switch (key)
						{
							case "song":
								var songParts:Array<String> = value.split(",");
								this.weekData.push({
									value: songParts
								});

							case "weekImage":
								hasCustomWeekImage = true;
								customWeekImage = value;
						}
					}
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.justPressed("up") || Controls.justPressed("down"))
			changeWeek(Controls.justPressed("up") ? -1 : 1);

		if (Controls.justPressed("accept")) // test
		{
			PlayState.storyPlaylist = weekData[curWeek];
			FlxG.switchState(() -> new PlayState());
		}
	}

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpMenuWeek.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0))
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('menu/scrollMenu'));
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (stopspamming == false)
		{
			FlxG.sound.play(Paths.sound('menu/confirmMenu'));

			grpMenuWeek.members[curWeek].startFlashing();
			// grpWeekCharacters.members[1].animation.play('bfConfirm');
			stopspamming = true;
		}

		PlayState.storyPlaylist = weekData[curWeek];
		PlayState.isStoryMode = true;
		selectedWeek = true;

		var diffic = "";

		switch (curDifficulty)
		{
			case 0:
				diffic = '-easy';
			case 2:
				diffic = '-hard';
		}

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.storyWeek = curWeek;
		PlayState.campaignScore = 0;
		new FunkTimer(true, 1, function()
		{
			LoadingState.loadAndSwitchState(new PlayState(), true);
		});
	}
}
