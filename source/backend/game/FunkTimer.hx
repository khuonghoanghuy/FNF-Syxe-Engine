package backend.game;

import flixel.util.FlxTimer;

class FunkTimer extends FlxTimer
{
	public function new(startTime:Bool = true, time:Float = 0, onComplete:Dynamic = null)
	{
		super();
		if (startTime)
		{
			start(time, function(timer:FlxTimer)
			{
				if (onComplete != null)
				{
					onComplete();
				}
			});
		}
	}
}
