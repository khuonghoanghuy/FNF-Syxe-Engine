package backend.game;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class FunkSprite extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0, ?graphic:FlxGraphicAsset)
	{
		super(x, y, graphic);
		antialiasing = true; // Easy to Config
	}

	public function quickAddPrefixAnim(name:String, prefix:String, looped:Bool = false)
		animation.addByPrefix(name, prefix, 24, looped);

	public function quickAddIncAnim(name:String, prefix:String, incs:Array<Int>, looped:Bool = false)
		animation.addByIndices(name, prefix, incs, "", 24, looped);

	public function playAnim(name:String, force:Bool = false)
		animation.play(name, force);
}