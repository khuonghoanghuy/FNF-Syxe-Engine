package states;

import flixel.util.FlxColor;
import flixel.FlxG;
import backend.game.FunkGame;
import backend.game.FunkSprite;
import backend.game.FunkTimer;
import openfl.Assets;
import backend.CoolUtil;

typedef TitleData = {
    var gfPos:Array<Float>;
    var titlePos:Array<Float>;
    var logoPos:Array<Float>;
}

class TitleState extends MusicBeatState
{
    var titleData:TitleData;

    override function create() {
        super.create();

        // Start Intro
        var time:FunkTimer = new FunkTimer(true, 1, function() {
            initThing();
        });
    }    

    function initThing():Void {
        // Init modding system
        backend.PolyHandler.reload();

        // Init JSON
        titleData = cast tjson.TJSON.parse(Assets.getText(Paths.data("titleJson.json")));

        var time = new FunkTimer(true, 1, function () {
            startIntro(); 
        });
    }

    function startIntro():Void {
        FunkGame.quickAddSprite({
            name: "titleText",
            x: titleData.titlePos[0], y: titleData.titlePos[1],
            withFrames: true, framesType: "sparrow", image: "titleEnter"
        });
        cast(FunkGame.getVariable("titleText"), FunkSprite).quickAddPrefixAnim("idle", "Press Enter to Begin", true);
        cast(FunkGame.getVariable("titleText"), FunkSprite).quickAddPrefixAnim("pressed", "ENTER PRESSED", true);
        cast(FunkGame.getVariable("titleText"), FunkSprite).playAnim("idle", true);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER) {
            camera.flash(FlxColor.WHITE, 2);
            cast(FunkGame.getVariable("titleText"), FunkSprite).playAnim("pressed", true);
        }
    }
}