package states;

import backend.game.FunkTimer;

class TitleState extends MusicBeatState
{
    override function create() {
        super.create();

        // Start Intro
        FunkTimer(true, 1, function () {
            initThing();
        });
    }    

    function initThing():Void {
        FunkTimer(true, 1, function () {
            startIntro(); 
        });
    }

    function startIntro():Void {
        
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}