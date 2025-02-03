package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sys.FileSystem;
import sys.io.File;
import tjson.TJSON;

using StringTools;

class FreeplayState extends MusicBeatState
{
    var songs:Array<SongMetaData> = [];
    var groupSong:FlxTypedGroup<Alphabet>;
    var iconArray:Array<HealthIcon> = [];
    var bg:FlxSprite;
    var coolColors:Array<String> = [];
    var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
    var lerpScore:Float = 0;
	var intendedScore:Int = 0;

    var curSelected:Int = 0;
    var curDifficulty:Int = 1;

    override function create() {
        super.create();

        bg = new FlxSprite(0, 0, Paths.image("menuDesat"));
        bg.scrollFactor.set();
        add(bg);

        loadJsonFile();

        groupSong = new FlxTypedGroup<Alphabet>();
        add(groupSong);

        for (i in 0...songs.length) {
            var text:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
            text.isMenuItem = true;
            text.targetY = i;
            groupSong.add(text);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = text;
			iconArray.push(icon);
			add(icon);
        }

        scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0x99000000);
		scoreBG.antialiasing = false;
		add(scoreBG);
        add(scoreText);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(diffText);

        changeSelection();
        changeDiff();
    } 

    function loadJsonFile() {
        var weekFiles:Array<String> = FileSystem.readDirectory(Paths.data("weeks/"));
        
        for (fileName in weekFiles) {
            if (fileName.endsWith(".json")) {
                var jsonString:String = File.getContent(Paths.data("weeks/" + fileName));
                var jsonData:Dynamic = TJSON.parse(jsonString);
                
                var songNames:Array<String> = jsonData.songs;
                var songCharacters:Array<String> = jsonData.songCharacter;
                var songColors:Array<String> = jsonData.songFreeplayColor;

                for (i in 0...songNames.length) {
                    var song:SongMetaData = new SongMetaData(songNames[i], 0, songCharacters[i], songColors[i]);
                    coolColors.push(song.songColor);
                    songs.push(song);
                }
            }
        }
    }
    
    public function addSong(songName:String, weekNum:Int, songCharacter:String)
		songs.push(new SongMetaData(songName, weekNum, songCharacter));

    public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);
        bg.color = FlxColor.interpolate(bg.color, FlxColor.fromString(coolColors[songs[curSelected].week % coolColors.length]), CoolUtil.camLerpShit(0.045));

        positionHighscore();

        if (Controls.justReleased("exit")) {
            FlxG.switchState(MainMenuState.new);
        }

        if (Controls.justPressed("up") || Controls.justPressed("down"))
            changeSelection((Controls.justPressed("up") ? -1 : 1));
    }

    function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		intendedScore = HighScore.getScore(songs[curSelected].songName, curDifficulty);

		PlayState.storyDifficulty = curDifficulty;

		diffText.text = "< " + CoolUtil.difficultyString() + " >";
		positionHighscore();
	}

    function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
        var bullShit:Int = 0;

        intendedScore = HighScore.getScore(songs[curSelected].songName, curDifficulty);

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}
		iconArray[curSelected].alpha = 1;
		for (item in groupSong.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
    }

    function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;

		diffText.x = Std.int(scoreBG.x + scoreBG.width / 2);
		diffText.x -= (diffText.width / 2);
	}
}