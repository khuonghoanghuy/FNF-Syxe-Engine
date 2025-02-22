package backend.popup;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Shape;
import openfl.events.MouseEvent;

class Alert extends Sprite
{
	private var background:Shape;
	private var titleText:TextField;
	private var messageText:TextField;
	private var closeButton:Sprite;

	public function new(message:String, title:String = "Alert")
	{
		super();

		// Create background
		background = new Shape();
		background.graphics.beginFill(0xFFFFFF);
		background.graphics.drawRect(0, 0, 300, 200);
		background.graphics.endFill();
		addChild(background);

		// Create title text
		var titleFormat = new TextFormat("Arial", 20, 0x000000, true);
		titleText = new TextField();
		titleText.defaultTextFormat = titleFormat;
		titleText.text = title;
		titleText.x = 10;
		titleText.y = 10;
		titleText.width = 280;
		titleText.height = 30;
		addChild(titleText);

		// Create message text
		var messageFormat = new TextFormat("Arial", 16, 0x000000);
		messageText = new TextField();
		messageText.defaultTextFormat = messageFormat;
		messageText.text = message;
		messageText.x = 10;
		messageText.y = 50;
		messageText.width = 280;
		messageText.height = 120;
		messageText.wordWrap = true;
		addChild(messageText);

		// Create close button
		closeButton = new Sprite();
		closeButton.graphics.beginFill(0xFF0000);
		closeButton.graphics.drawRect(0, 0, 80, 30);
		closeButton.graphics.endFill();
		closeButton.x = 110;
		closeButton.y = 160;
		var buttonText = new TextField();
		buttonText.defaultTextFormat = new TextFormat("Arial", 16, 0xFFFFFF);
		buttonText.text = "Close";
		buttonText.x = 10;
		buttonText.y = 5;
		closeButton.addChild(buttonText);
		closeButton.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
		addChild(closeButton);
	}

	private function onCloseButtonClick(event:MouseEvent):Void
	{
		this.parent.removeChild(this);
	}

	public static function show(message:String, title:String = "Alert"):Void
	{
		var alert = new Alert(message, title);
		openfl.Lib.current.stage.addChild(alert);
		alert.x = (openfl.Lib.current.stage.stageWidth - alert.width) / 2;
		alert.y = (openfl.Lib.current.stage.stageHeight - alert.height) / 2;
	}
}
