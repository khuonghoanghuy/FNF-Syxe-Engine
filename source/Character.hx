package;

import tjson.TJSON;
import flixel.FlxSprite;
import haxe.Json;

typedef CharacterFile = {
    var animations:Array<AnimArray>;
    var image:String;
    var scale:Array<Float>;
    var sing_duration:Float;
    var healthicon:String;

    var position:Array<Float>;
    var camera_position:Array<Float>;

    var flip_x:Bool;
    var no_antialiasing:Bool;
    var healthbar_colors:Array<Int>;
}

typedef AnimArray = {
    var anim:String;
    var name:String;
    var fps:Int;
    var loop:Bool;
    var indices:Array<Int>;
    var offsets:Array<Int>;
}

class Character extends FlxSprite {
    public var characterData:CharacterFile;

    public function new(x:Float = 0, y:Float = 0, characterJson:String) {
        super(x, y);
        loadCharacterData(characterJson);
    }

    private function loadCharacterData(characterJson:String):Void {
        var jsonData = TJSON.parse(characterJson);
        characterData = cast jsonData;

        frames = Paths.getSparrowAtlas(characterData.image);

        scale.set(characterData.scale[0], characterData.scale[1]);

        if (characterData.position.length == 2) {
            setPosition(characterData.position[0], characterData.position[1]);
        }

        flipX = characterData.flip_x;

        for (anim in characterData.animations) {
            if (anim.indices != null)
                animation.addByIndices(anim.name, anim.anim, anim.indices, "", anim.fps, anim.loop);
            else
                animation.addByPrefix(anim.name, anim.anim, anim.fps, anim.loop);
        }
    }
}