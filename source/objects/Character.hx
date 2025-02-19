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

	var animationOffsets:Map<String, {x:Float, y:Float}> = new Map();

	public function new(x:Float = 0, y:Float = 0, char:String = "bf", isPLayer:Bool = false)
	{
		super(x, y);

		this.name = char;
		this.isPlayer = isPLayer;
		this.animations = new StringMap<String>();
		this.characterData = new StringMap<String>();

		loadDataFromText(if (char == null) getDefaultCharacterData() else getFile(name));
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
					// case "animation_name":
					// 	currentAnimationName = value;
					case "animation_data":
						if (currentAnimationName != null)
						{
							var animationData = parseAnimationData(value);
							this.animation.addByPrefix(animationData.name, animationData.prefix, animationData.frameRate, animationData.loop);
							// currentAnimationName = null; // Reset for the next animation
						}
					case "scaleX":
						this.scale.x = Std.parseFloat(value);
					case "scaleY":
						this.scale.y = Std.parseFloat(value);
					default:
						// Store any other key-value pairs in characterData
						characterData.set(key, value);
				}
			}
		}
	}

	private function getDefaultCharacterData():String
	{
		return '
            name::bf

            animation_name::singLEFT
            animation_data::BF SING LEFT

            animation_name::singRIGHT
            animation_data::BF SING RIGHT

            animation_name::singUP
            animation_data::BF SING UP

            animation_name::singDOWN
            animation_data::BF SING DOWN

            animation_name::idle
            animation_data::BF IDLE
        ';
	}

	function parseAnimationData(data:String):Dynamic
	{
		// Example: Parse a string like "prefix,24,true" (prefix, frameRate, loop)
		var parts:Array<String> = data.split(",");
		return {
			name: parts[0],
			prefix: parts[1], // Animation prefix in the spritesheet
			frameRate: Std.parseInt(parts[2]) == 24, // Frame rate of the animation
			loop: parts[3] == "true" // Whether the animation loops
		};
	}
}
