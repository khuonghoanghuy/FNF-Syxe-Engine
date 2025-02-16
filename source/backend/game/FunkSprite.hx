package backend.game;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class FunkSprite extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, ?graphic:FlxGraphicAsset) {
        super(x, y, graphic);
        antialiasing = true; // Easy to Config
    }    
}