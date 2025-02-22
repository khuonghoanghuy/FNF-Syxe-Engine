package objects;

import backend.chart.Conductor;
import openfl.Assets;
import haxe.ds.StringMap;
import backend.game.FunkSprite;

using StringTools;

class Character extends FunkSprite
{
	public var name:String = "bf";
	public var animations:StringMap<String>;
	public var characterData:StringMap<String>;
	public var isPlayer:Bool = false;
	public var icon:String = "bf";
	public var healthColor:String = "0x3291cb";

	var animationOffsets:Map<String, Array<Dynamic>>;

	public function new(x:Float = 0, y:Float = 0, char:String = "bf", isPLayer:Bool = false)
	{
		super(x, y);

		animationOffsets = new Map<String, Array<Dynamic>>();

		this.name = char;
		this.isPlayer = isPLayer;
		this.animations = new StringMap<String>();
		this.characterData = new StringMap<String>();

		loadDataFromText(getFile(name));
	}

	function getFile(nameChar:String)
		return Assets.getText(Paths.data("characters/" + nameChar + ".txt"));

	public function loadDataFromText(textData:String):Void
	{
		var lines:Array<String> = textData.split("\n");
		var currentAnimationName:String = null;

		for (line in lines)
		{
			line = StringTools.trim(line); // Remove leading/trailing whitespace

			// Skip empty lines or comments
			if (line == "" || line.startsWith("#"))
				continue;

			// Split key::value pairs
			if (line.indexOf("::") != -1)
			{
				var parts:Array<String> = line.split("::");
				var key:String = StringTools.trim(parts[0]);
				var value:String = StringTools.trim(parts[1]);

				switch (key)
				{
					case "name":
						this.name = value;
					case "animation_frames":
						this.frames = Paths.getSparrowAtlas('characters/$value');
					case "animation_prefix_data":
						// Split the value into parts
						var parts:Array<String> = value.split(",");
						var name:String = parts[0];
						var frame:String = parts[1];
						var speed:Int = Std.parseInt(parts[2]);
						var loop:Bool = parts[3] == "false";

						// Store the animation data
						this.animation.addByPrefix(name, frame, speed, loop);
						currentAnimationName = name;
					case "animation_indices_data":
						var parts:Array<String> = value.split(",");
						var name:String = parts[0];
						var prefix:String = parts[1];
						var ind:Array<Int> = backend.CoolUtil.genNumFromTo(Std.parseInt(parts[2]), Std.parseInt(parts[3]));
						var postfix:String = parts[4];
						var speed:Int = Std.parseInt(parts[5]);
						var loop:Bool = parts[6] == "false";

						this.animation.addByIndices(name, prefix, ind, postfix, speed, loop);
					case "animation_offset":
						// Split the value into parts
						var parts:Array<String> = value.split(",");
						var name:String = parts[0];
						var x:Float = Std.parseFloat(parts[1]);
						var y:Float = Std.parseFloat(parts[2]);

						// Store the animation offset
						addOffset(name, x, y);
					case "icon":
						this.icon = value;
					case "healthColor":
						this.healthColor = value;
					default:
						// Store any other key-value pairs in characterData
						characterData.set(key, value);
				}
			}
		}
	}

	public var holdTimer:Float = 0.1;

	override function playAnim(name:String, force:Bool = false)
	{
		var daOffset = animationOffsets.get(name);
		if (animationOffsets.exists(name))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		super.playAnim(name, force);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!name.startsWith('bf'))
		{
			if (animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (name == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}
	}

	public function dance()
	{
		var daOffset = animationOffsets.get(name);
		if (animationOffsets.exists(name))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		// for every character
		if (this.animation.exists("idle"))
			this.animation.play("idle");

		// for character have danceLeft/danceRight
		if (this.animation.exists("danceLeft") && this.animation.curAnim.name != "danceLeft")
			this.animation.play("danceLeft");
		else if (this.animation.exists("danceRight") && this.animation.curAnim.name != "danceRight")
			this.animation.play("danceRight");
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		var daOffset = animationOffsets.get(name);
		if (animationOffsets.exists(name))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
		animationOffsets[name] = [x, y];
	}
}
