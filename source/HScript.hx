package;

import crowplexus.iris.Iris;
import sys.io.File;

using StringTools;

class HScript extends Iris
{
    public function new(fileContent:String) {
        super(File.getContent(fileContent));

        // Classes Already Imported
        set("FlxG", flixel.FlxG);
        set("FlxSprite", flixel.FlxSprite);
        set("FlxCamera", flixel.FlxCamera);
        
        // These Function
        set("add", function (basic:flixel.FlxBasic) {
            return flixel.FlxG.state.add(basic);
        });
        set("remove", function (basic:flixel.FlxBasic) {
            flixel.FlxG.state.remove(basic);
        });
        set("insert", function (pos:Int, basic:flixel.FlxBasic) {
            flixel.FlxG.state.insert(pos, basic);
        });
        
        config.name = fileContent.split('/').pop();
        config.autoPreset = config.autoRun = true;
    }

    override function call(fun:String, ?args:Array<Dynamic>):IrisCall {
        if (fun == null || !exists(fun)) return null;
        return super.call(fun, args);
    }
}