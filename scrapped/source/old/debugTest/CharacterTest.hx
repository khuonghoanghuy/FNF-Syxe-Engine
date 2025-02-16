package debugTest;

import flixel.addons.ui.FlxUIList;
import flixel.FlxG;

using StringTools;

class CharacterTest extends MusicBeatState
{
    var character:Character;
    var name:String = "dad";
    var list:FlxUIList;
    var moreVar:String = "More...";

    override function create() {
        super.create();

        character = new Character(0, 0, name, false);
        character.playAnim("idle");
        character.screenCenter();
        add(character);

        list = new FlxUIList(10, 10, null, 100, 100, moreVar);

        camera.zoom = 0.85;
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        character.animation.onFinish.add(function (name:String) {
            switch (name) {
                case "singLEFT" | "singRight" | "singUP" | "singDOWN":
                    character.playAnim("idle", true);
            }
        });

        if (FlxG.keys.justPressed.SPACE)
            character.playAnim("idle", true);

        if (FlxG.keys.justPressed.LEFT)
            character.playAnim("singLEFT", true);

        if (FlxG.keys.justPressed.RIGHT)
            character.playAnim("singRIGHT", true);

        if (FlxG.keys.justPressed.UP)
            character.playAnim("singUP", true);

        if (FlxG.keys.justPressed.DOWN)
            character.playAnim("singDOWN", true);

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(MainMenuState.new);
    }

    override function beatHit() {
        super.beatHit();

        if (curBeat % 4 == 0) {
            if (!character.animation.curAnim.name.startsWith("sing"))
                character.playAnim("idle", true);
        }
    }
}