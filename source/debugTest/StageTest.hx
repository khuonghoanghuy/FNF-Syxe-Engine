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
        	dad = new Character(stageData.stageJson.dadPos[0], stageData.stageJson.dadPos[1], "dad");
        	add(dad);
        	gf = new Character(stageData.stageJson.gfPos[0], stageData.stageJson.gfPos[1], "gf");
        	add(gf);
        	bf = new Character(stageData.stageJson.bfPos[0], stageData.stageJson.bfPos[1], "bf", true);
        	add(bf);
        }
        catch (e:haxe.Exception)
        {
        	// TODO: handle exception
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