package;

import openfl.text.TextFormat;
import flixel.util.FlxColor;
import openfl.display.FPS;
import flixel.FlxG;
import openfl.display.Sprite;
import flixel.FlxGame;

class Main extends Sprite
{
    var game:FlxGame;
    public function gameConfig() {
        return {
            "width": FlxG.width,
            "height": FlxG.height,
            "states": null, // Set a State to load game
            "fps": #if html5 60 #else 144 #end,
            "introHaxe": false
        }
    }
    var fpsCounter:FPS;
    public function fpsConfig() {
        return {
            "x": 10,
            "y": 3,
            "color": FlxColor.fromString("0xFFFFFF"),
            "font": "vcr"
        };
    }

    public function new() {
        super();

        game = new FlxGame(gameConfig().width, gameConfig().height, gameConfig().states, gameConfig().fps, gameConfig().fps, gameConfig().introHaxe, false);
        // Init Game
        addChild(game);

        fpsCounter = new FPS(fpsConfig().x, fpsConfig().y, fpsConfig().color);
        // Set Font for FPS
        fpsCounter.defaultTextFormat = new TextFormat(fpsConfig().font);
        addChild(fpsCounter);
    }    
}