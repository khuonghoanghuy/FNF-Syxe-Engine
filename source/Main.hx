package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));
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
