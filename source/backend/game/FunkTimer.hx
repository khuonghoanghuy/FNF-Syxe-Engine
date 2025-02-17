package backend.game;

import flixel.util.FlxTimer;

class FunkTimer extends FlxTimer
{
	public function new(startTime:Bool = true, time:Float = 0, onComplete:Dynamic)
	{
		super();
		if (startTime)
		{
			start(time, function(timer:FlxTimer)
			{
				onComplete();
			});
		}
	}
}