package;

import flixel.FlxState;
import openfl.display.FPS;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class Main extends Sprite
{
	var state:Class<FlxState> = TitleState;

	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, state));
		addChild(new FPS(10, 3, 0xFFFFFF));

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyFullScreen);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyRestartGame);
	}
	
	function onKeyFullScreen(event:KeyboardEvent):Void {
		if (event.keyCode == Keyboard.F11) {
			stage.displayState = (stage.displayState == StageDisplayState.FULL_SCREEN) ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
		}
	}

	function onKeyRestartGame(event:KeyboardEvent):Void {
		if (event.keyCode == Keyboard.F5)
		{
			FlxG.resetState();
		}
	}
}
