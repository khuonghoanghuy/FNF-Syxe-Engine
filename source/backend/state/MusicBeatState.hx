package backend.state;

import backend.game.FunkGame;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
    override function create() {
        super.create();

        FunkGame.clearVariable();
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}