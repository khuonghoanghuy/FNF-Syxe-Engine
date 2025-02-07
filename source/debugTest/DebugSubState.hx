package debugTest;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;

class DebugSubState extends MusicBeatSubState
{
    var arrayList:Array<String> = ["Character JSON", "Stage Test"];
    var groupList:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;

    override function create() {
        super.create();

        groupList = new FlxTypedGroup<Alphabet>();
        add(groupList);

        for (i in 0...arrayList.length) {
            var text:Alphabet = new Alphabet(0, (70 * i) + 30, arrayList[i], true, false);
            text.isMenuItem = true;
            text.targetY = i;
            groupList.add(text);
        }

        changeSelection();
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Controls.justPressed("up") || Controls.justPressed("down"))
            changeSelection((Controls.justPressed("up") ? -1 : 1));

        if (Controls.justPressed("accept")) {
            switch (arrayList[curSelected]) {
                case "Character JSON":
                    FlxG.switchState(CharacterTest.new);
                case "Stage Test":
                    FlxG.switchState(StageTest.new);
            }
        }

        if (Controls.justPressed("exit")) {
            close();
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, arrayList.length - 1);
        var bullShit:Int = 0;
        for (item in groupList.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
    }
}