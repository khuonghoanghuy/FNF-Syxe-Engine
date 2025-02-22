package objects;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		super(x, y, char, true);
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
		{
			holdTimer += elapsed;
		}
		else
			holdTimer = 0;

		if (animation.curAnim != null && animation.curAnim.name.endsWith('miss') && animation.curAnim.finished)
		{
			playAnim('idle', true);
		}

		if (animation.curAnim != null && animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
		{
			playAnim('deathLoop');
		}

		super.update(elapsed);
	}
}
