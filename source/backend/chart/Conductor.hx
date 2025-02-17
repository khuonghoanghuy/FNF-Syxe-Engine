package backend.chart;

import backend.chart.Song.SwagSong;

/**
 * ...
 * @author
 */
typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Int;
}
class Conductor
{
    public static var bpm:Int = 100;
    public static var crochet:Float = (60 / bpm) * 1000;
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float;
    public static var lastSongPos:Float;
    public static var offset:Float = 0;

    public static var safeFrames:Int = 10;
    public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    public static var bpmChangeMap:Array<BPMChangeEvent> = [];

    public static function mapBPMChanges(song:SwagSong)
    {
        bpmChangeMap = [];
        var curBPM:Int = song.bpm;
        var totalSteps:Int = 0;
        var totalPos:Float = 0;

        for (note in song.notes)
        {
            if(note.changeBPM && note.bpm != curBPM)
            {
                curBPM = note.bpm;
                bpmChangeMap.push({ stepTime: totalSteps, songTime: totalPos, bpm: curBPM });
            }

            totalSteps += note.lengthInSteps;
            totalPos += (60 / curBPM) * 250 * note.lengthInSteps;
        }
        trace("new BPM map BUDDY " + bpmChangeMap);
    }

    public static function changeBPM(newBpm:Int)
    {
        bpm = newBpm;
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / 4;
    }
}
