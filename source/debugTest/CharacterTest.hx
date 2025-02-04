package debugTest;

import flixel.FlxG;

class CharacterTest extends MusicBeatState
{
    var character:Character;
    var name:String = "dad";

    override function create() {
        super.create();

        character = new Character(0, 0, name, false);
        character.animation.play("idle");
        character.screenCenter();
        add(character);
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        character.animation.onFinish.add(function (name:String) {
            switch (name) {
                case "singLEFT" | "singRight" | "singUP" | "singDOWN":
                    character.animation.play("idle");
            }
        });

        if (FlxG.keys.justPressed.SPACE)
            character.animation.play("idle");

        if (FlxG.keys.justPressed.LEFT)
            character.animation.play("singLEFT");

        if (FlxG.keys.justPressed.RIGHT)
            character.animation.play("singRIGHT");

        if (FlxG.keys.justPressed.UP)
            character.animation.play("singUP");

        if (FlxG.keys.justPressed.DOWN)
            character.animation.play("singDOWN");

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(TitleState.new);
    }
}