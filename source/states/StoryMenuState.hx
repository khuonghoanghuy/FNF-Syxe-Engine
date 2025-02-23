package states;

import backend.HighScore;
import backend.CoolUtil;
import flixel.util.FlxColor;
import backend.game.FunkSprite;
import flixel.group.FlxGroup;
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
	var weekNames:Array<String> = [];
	var curWeek:Int = 0;
	var curDifficult:Int = 0;

	var grpMenuWeek:FlxTypedGroup<MenuItem>;
	var grpMenuCharacter:FlxTypedGroup<MenuCharacter>;
	var curDifficulty(default, null):Int = 0;

	var txtWeekTitle:FlxText;
	var txtTracklist:FlxText;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FunkSprite;
	var leftArrow:FunkSprite;
	var rightArrow:FunkSprite;

	override function create()
	{
		super.create();

		loadTxtWeekFile();

		var yellowBG:FunkSprite = new FunkSprite(0, 56);
		yellowBG.makeGraphic(FlxG.width, 400, 0xFFF9CF51);
		add(yellowBG);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32, OUTLINE, FlxColor.BLACK);
		add(scoreText);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		txtWeekTitle.alpha = 0.7;
		add(txtWeekTitle);

		var blackBarThingie:FunkSprite = new FunkSprite();
		blackBarThingie.makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

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

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.setFormat("VCR OSD Mono", 32, FlxColor.fromString("0xFFe55777"), RIGHT, OUTLINE, FlxColor.BLACK);
		add(txtTracklist);

		updateText();
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
							case "name":
								this.weekNames.push(value);
							case "weekImage":
								hasCustomWeekImage = true;
								customWeekImage = value;
						}
					}
				}
			}
		}
	}

	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.5);
		scoreText.text = "WEEK SCORE:" + Math.round(lerpScore);
		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		if (Controls.justPressed("up") || Controls.justPressed("down"))
			changeWeek(Controls.justPressed("up") ? -1 : 1);

		if (Controls.justPressed("accept")) // test
		{
			selectWeek();
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
		updateText();
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

		PlayState.storyPlaylist = weekData[curWeek].value;
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

	function updateText()
	{
		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData[curWeek].value;

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		intendedScore = HighScore.getWeekScore(curWeek, curDifficulty);
	}
}
