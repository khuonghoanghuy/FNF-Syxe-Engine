package objects;

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

	var animationOffsets:Map<String, {x:Float, y:Float}> = new Map();

	public function new(x:Float = 0, y:Float = 0, char:String = "bf", isPLayer:Bool = false)
	{
		super(x, y);

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
					case "animation_offset":
						// Split the value into parts
						var parts:Array<String> = value.split(",");
						var x:Float = Std.parseFloat(parts[0]);
						var y:Float = Std.parseFloat(parts[1]);

						// Store the animation offset
						this.animationOffsets.set(currentAnimationName, {x: x, y: y});
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
}
