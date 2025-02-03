package;

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
    var titleWeek:FlxText;

    override function create() {
        super.create();

        titleWeek = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
        titleWeek.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        titleWeek.scrollFactor.set();
        add(titleWeek);
    }

    function loadJsonFile() {
        var weekFiles:Array<String> = FileSystem.readDirectory(Paths.data("weeks/"));
        
        for (fileName in weekFiles) {
            if (fileName.endsWith(".json")) {
                var jsonString:String = File.getContent(Paths.data("weeks/" + fileName));
                var jsonData:Dynamic = TJSON.parse(jsonString);
                
                var songNames:Array<String> = jsonData.songs;
                var songCharacters:Array<String> = jsonData.songCharacter;
                var songColors:Array<String> = jsonData.colorStoryWeek;

                for (i in 0...songNames.length) {
                    var song:SongMetaData = new SongMetaData(songNames[i], 0, songCharacters[i], songColors[i]);
                    coolColors.push(song.songColor);
                   // songs.push(song);
                }
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    
        if (Controls.justReleased("exit"))
            FlxG.switchState(MainMenuState.new);
    }
}