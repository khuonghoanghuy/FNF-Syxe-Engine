package states.debugbugbugbug;

import flixel.FlxG;
import objects.Character;

class HolyShitISTHATCHARACTEREDITOR extends MusicBeatState
{
	var char:Character;

	override function create()
	{
		super.create();

		char = new Character(0, 0, "bf", true);
		char.name = "bf";
		char.playAnim("idle");
		add(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		char.animation.onFinish.add(function(animName:String)
		{
			char.playAnim("idle", true);
		});

		if (FlxG.keys.justPressed.ENTER)
		{
			char.playAnim("idle", true);
		}
	}
}
