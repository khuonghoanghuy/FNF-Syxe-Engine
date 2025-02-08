package debugTest;

import flixel.FlxG;

class StageTest extends MusicBeatState
{
    // Main thing
    var stageName:String = 'stage';
    var stageData:StageData;

    // Char thing
    var dad:Character;
    var gf:Character;
    var bf:Character;
    
    override function create() {
        super.create();
        
        try {
        	stageData = new StageData(stageName);
        	stageData.stageScript.execute();
        }
        catch (e:haxe.Exception)
        {
        	trace(e.details());
            FlxG.switchState(MainMenuState.new);
        }
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(MainMenuState.new);
    }
}