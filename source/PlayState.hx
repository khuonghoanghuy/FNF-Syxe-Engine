package;

import Song.SwagSong;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static var campaignScore:Int;
	public static var storyWeek:Int;
	public static var storyPlaylist:Dynamic;
	public static var isStoryMode:Bool = false;
	public static var storyDifficulty:Int;
	public static var SONG:SwagSong;
	public static var stageData:StageData;

	override public function create()
	{
		super.create();

		stageData = new StageData(SONG.stages);
		stageData.execute();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
