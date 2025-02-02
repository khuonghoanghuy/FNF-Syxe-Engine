package;

import crowplexus.iris.Iris;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import sys.io.File;

using StringTools;

class HScript extends Iris
{
    public function new(fileContent:String) {
        super(File.getContent(fileContent));

        // Classes
        setLotVar([
            "FlxG",
            "FlxSprite",
            "FlxCamera"
        ], [
            FlxG,
            FlxSprite,
            FlxCamera
        ]);

        // Function can used
        setLotVar([
            "add",
            "remove",
            "insert"
        ], [
            FlxG.state.add,
            FlxG.state.remove,
            FlxG.state.insert
        ]);
        
        config.name = fileContent.split('/').pop();
        config.autoPreset = config.autoRun = true;
    }

    override function call(fun:String, ?args:Array<Dynamic>):IrisCall {
        if (fun == null || !exists(fun)) return null;
        return super.call(fun, args);
    }    

    public function setLotVar(variable:Array<String>, value:Array<Dynamic>) {
        for (i in 0...variable.length) {
            Reflect.setProperty(this, variable[i], value[i]);
        }
    }
}