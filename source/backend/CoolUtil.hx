package backend;

import flixel.math.FlxMath;
import flixel.FlxG;

class CoolUtil
{
	public static function genNumFromTo(from:Int, to:Int):Array<Int>
	{
		try
		{
			var daNum:Array<Int> = [];
			for (i in from...to + 1)
			{
				daNum.push(i);
			}
			return daNum;
		}
		catch (e)
		{
			trace("Catch Error: " + e.message);
			return [0];
		}
	}

	/**
		Lerps camera, but accountsfor framerate shit?
		Right now it's simply for use to change the followLerp variable of a camera during update
		TODO LATER MAYBE:
			Actually make and modify the scroll and lerp shit in it's own function
			instead of solely relying on changing the lerp on the fly
	 */
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	/*
	 * just lerp that does camLerpShit for u so u dont have to do it every time
	 */
	public static function coolLerp(a:Float, b:Float, ratio:Float):Float
	{
		return FlxMath.lerp(a, b, camLerpShit(ratio));
	}
}
