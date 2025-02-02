package;

import flixel.FlxSprite;
import sys.io.File;
import tjson.TJSON;

typedef MenuCharacterData = {
    name:String,
    assets:String,
    anim:String,
    offset:Array<Int>
}

class MenuCharacter extends FlxSprite
{
    public var character:String = 'bf';

    public function new(x:Float, character:String = 'bf') {
        super(x);

        changeCharacter(character);
    }    

    function changeCharacter(name:String = "bf") {
		if(name == null) name = '';
		if(name == this.character) return;
        
        visible = true;
        scale.set(1, 1);
        updateHitbox();

        switch (name) {
            case '':
                visible = false;
            default: 
                visible = true;

                var characterFile:MenuCharacterData = cast TJSON.parse(File.getContent(Paths.data('characters/${name}.json')));
                frames = Paths.getSparrowAtlas("storymenu/props/" + characterFile.assets);
                animation.addByPrefix("idle", characterFile.anim, 24, false);
                animation.play("idle");

                offset.set(characterFile.offset[0], characterFile.offset[1]);
        }
    }
}