package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import openfl.Lib;

class MainMenuState extends MusicBeatState
{
    var versionText:FlxText;
    var groupMenuItem:FlxTypedGroup<FlxSprite>;
    var optionsText:Array<String> = ["storymode", "freeplay", "credits", "options"];
    var curSelected:Int = 0;
    var bg:FlxSprite;
    
    override function create() {
        super.create();

        bg = new FlxSprite(0, 0);
        bg.loadGraphic(Paths.image("menuBG"));
        add(bg);

        groupMenuItem = new FlxTypedGroup<FlxSprite>();
        add(groupMenuItem);

		for (num => option in optionsText)
		{
			var item:FlxSprite = createMenuItem(option, 0, (num * 140) + 90);
			item.y += (4 - optionsText.length) * 70;
			item.screenCenter(X);
		}

        versionText = new FlxText(10, FlxG.height - 22, 0, "Syxe Engine v" + Lib.application.meta.get("version"), 12);
        versionText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        versionText.scrollFactor.set();
        add(versionText);
    }    

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		
		menuItem.scrollFactor.set();
		groupMenuItem.add(menuItem);
		return menuItem;
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        mouseHandler();

        if (FlxG.keys.justPressed.F12)
            openSubState(new debugTest.DebugSubState());
    }

    function mouseHandler():Void {
        for (item in groupMenuItem.members) {
            if (item.overlapsPoint(FlxG.mouse.getWorldPosition())) {
                item.animation.play('selected');
                if (FlxG.mouse.pressed) {
                    for (i in 0...groupMenuItem.length) {
                        if (groupMenuItem.members[i].overlapsPoint(FlxG.mouse.getWorldPosition())) {
                            switch (i) {
                                case 0: // story mode
                                    FlxG.switchState(StoryMenuState.new);
                                case 1: // freeplay
                                    FlxG.switchState(FreeplayState.new);
                                case 2: // credits
                                case 3: // options
                            }
                        }
                    }
                }
            } else {
                item.animation.play('idle');
            }
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, optionsText.length - 1);
        for (item in groupMenuItem.members)
            item.animation.play('selected');
    }
}