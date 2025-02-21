package objects;

import openfl.Assets;
import backend.game.FunkSprite;

using StringTools;

class MenuCharacter extends FunkSprite
{
	public var character:String;
	public var isHavingConfirm:Bool = false;

	var animationOffsets:Map<String, Array<Dynamic>>;

	public function new(x:Float, character:String = 'bf')
	{
		animationOffsets = new Map<String, Array<Dynamic>>();

		super(x);

		loadDataFromText(getFile(character));
	}

	function getFile(nameChar:String)
		return Assets.getText(Paths.data("week/characters/" + nameChar + ".txt"));

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
						this.character = value;
					case "pos":
						var parts:Array<String> = value.split(",");
						var value:Array<Float> = [Std.parseFloat(parts[0]), Std.parseFloat(parts[1])];
						this.setPosition(value[0], value[1]);
					case "isHavingConfirm":
						var bool:Bool = value == "true";
						this.isHavingConfirm = bool;
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
					case "animation_offset":
						// Split the value into parts
						var parts:Array<String> = value.split(",");
						var name:String = parts[0];
						var x:Float = Std.parseFloat(parts[1]);
						var y:Float = Std.parseFloat(parts[2]);

						// Store the animation offset
						addOffset(name, x, y);
				}
			}
		}
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
