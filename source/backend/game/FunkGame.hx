package backend.game;

import flixel.FlxBasic;
import flixel.FlxG;

class FunkGame {
    // Map to store game variables
    private static var mapVariableGame:Map<String, FlxBasic> = new Map<String, FlxBasic>();

    // Retrieve a variable from the map
    public static function getVariable<T:FlxBasic>(name:String):T {
        return cast mapVariableGame.get(name);
    }

    // Set a variable in the map
    public static function setVariable<T:FlxBasic>(name:String, value:T):Void {
        mapVariableGame.set(name, value);
    }

    // Clear all variables in the map
    public static function clearVariable():Void {
        mapVariableGame.clear();
    }

    /**
     * Quick Add the Sprite without gonna do the init and add, also is will pass into a map variable!
     * 
     * @param pros the array of dynamic, for example: 
     * ```haxe
     * FunkGame.quickAddSprite({x: 100, y: 100, name: "myGraphic", image: "myGraphic"})
     * ```
     */
    public static function quickAddSprite(pros:Dynamic) {
        try {
            var sprite:FunkSprite = new FunkSprite(pros.x, pros.y);
            if (pros.onlyLoad) {
                sprite.loadGraphic(pros.image, pros.isAnimate, pros.frameWidth, pros.frameHeight);
            }
            if (pros.withFrames) {
                switch (pros.framesType) {
                    case "sparrow":
                        sprite.frames = Paths.getSparrowAtlas(pros.image);
                    case "packer":
                        sprite.frames = Paths.getPackerAtlas(pros.image);
                }
            }
            sprite.active = true;
            sprite.updateHitbox();
            setVariable(Std.string(pros.name), sprite);
            FlxG.state.add(sprite);
        } catch (e) {
            trace("Catch Error: " + e.message);
        }
    }
}
