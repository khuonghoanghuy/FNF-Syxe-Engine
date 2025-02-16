package states;

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
        FunkTimer(true, 1, function () {
            initThing();
        });
    }    

    function initThing():Void {
        // Init modding system
        backend.PolyHandler.init();
        // Init JSON
        titleData = tjson.TJSON(Assets.getText(Paths.data("titleJson.json")));

        FunkTimer(true, 1, function () {
            startIntro(); 
        });
    }

    var gfDance:FunkSprite;
    
    function startIntro():Void {
        gfDance = new FunkSprite(titleData.gfPos[0], titleData.gfPos[1]);
        gfDance.quickAddIncAnim("danceLeft", "gfDance", CoolUtil.genNumFromTo(0, 14));
        gfDance.quickAddIncAnim("danceRight", "gfDance", CoolUtil.genNumFromTo(15, 30));
        add(gfDance);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}