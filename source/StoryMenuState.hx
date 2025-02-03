package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import tjson.TJSON;
import sys.io.File;
import sys.FileSystem;

using StringTools;

class StoryMenuState extends MusicBeatState {
    var yellowBG:FlxSprite;
    var coolColors:Array<String> = [];
    var titleWeekName:FlxText;
    var groupMenuItem:FlxTypedGroup<MenuItem>;
    var groupMenuCharacter:FlxTypedGroup<MenuCharacter>;

    var weekData:Array<Dynamic> = [];

    var curSelected:Int = 0;

    override function create() {
        super.create();

        loadJsonFile();

        persistentUpdate = persistentDraw = true;

        yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFFFFFFF);
        add(yellowBG);

        titleWeekName = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
        titleWeekName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        titleWeekName.scrollFactor.set();
        add(titleWeekName);

        groupMenuItem = new FlxTypedGroup<MenuItem>();
        add(groupMenuItem);

        for (i in 0...weekData.length) {
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
            weekThing.screenCenter(X);
			groupMenuItem.add(weekThing);
        }
    }

    function loadJsonFile() {
        var weekFiles:Array<String> = FileSystem.readDirectory(Paths.data("weeks/"));
        
        for (fileName in weekFiles) {
            if (fileName.endsWith(".json")) {
                var jsonString:String = File.getContent(Paths.data("weeks/" + fileName));
                var jsonData:Dynamic = TJSON.parse(jsonString);
                
                var songNames:Array<String> = jsonData.songs;
                var songCharacters:Array<String> = jsonData.weekCharacter;
                var songColors:Array<String> = jsonData.colorStoryWeek;

                for (i in 0...songNames.length) {
                    var song:SongMetaData = new SongMetaData(songNames[i], 0, songCharacters[i], songColors[i]);
                    coolColors.push(song.songColor);
                    titleWeekName.text = jsonData.nameWeek;
                    // songs.push(song);
                }
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        yellowBG.color = FlxColor.interpolate(yellowBG.color, FlxColor.fromString(coolColors[curSelected % coolColors.length]), CoolUtil.camLerpShit(0.045));
    
        if (Controls.justReleased("exit"))
            FlxG.switchState(MainMenuState.new);
    }
}