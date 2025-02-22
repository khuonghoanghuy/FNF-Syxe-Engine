package states;

import backend.game.FunkSprite;
import flixel.FlxG;
import backend.chart.Conductor;
import backend.chart.Section;
import backend.chart.Song;

// literally nothing works rn lol, we might be able to add actual functionality later
class ChartingState extends MusicBeatState
{
	public static var instance:ChartingState = null;
	public static var song:SwagSong = null;

	var gridBG:FlxSprite;
	var gridSize:Int = 40;
	var columns:Int = 4;
	var rows:Int = 16;

	var curSection:Int = 0;
	var dummyArrow:FlxSprite;

	var beatSnap:Int = 16;

	var renderedNotes:FlxTypedGroup<Note>;
	var curSelectedNote:Array<Dynamic> = [];

	var songInfoText:FlxText;

	var saveButton:FlxButton;
	var saveAsButton:FlxButton;

	var clearSectionButton:FlxButton;
	var clearSongButton:FlxButton;

	var sectionToCopy:Int = 0;
	var notesCopied:Array<Dynamic> = [];
	var copySectionButton:FlxButton;
	var pasteSectionButton:FlxButton;

	var bpmInput:FlxInputText;
	var setBPMButton:FlxButton;
	var loadSongButton:FlxButton;
	var loadSongFromButton:FlxButton;

	var strumLine:FlxSprite;

	var _file:FileReference;

	override public function new()
	{
		super();

		instance = this;
	}

	override public function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		Conductor.bpm = song.bpm;
		loadSong(Paths.formatToSongPath(song.song));
		beatSnap = Conductor.stepsPerSection;

		var bg:FunkSprite = new FunkSprite();
		bg.loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		bg.color = 0xFF888888;
		add(bg);

		gridBG = FlxGridOverlay.create(gridSize, gridSize, gridSize * columns, gridSize * rows, true, 0xFF404040, 0xFF525252);
		gridBG.screenCenter();
		add(gridBG);

		dummyArrow = new FlxSprite().makeGraphic(gridSize, gridSize);
		add(dummyArrow);

		renderedNotes = new FlxTypedGroup<Note>();
		add(renderedNotes);

		addSection();
		updateGrid();

		songInfoText = new FlxText(10, 10, 0, 18);
		add(songInfoText);

		saveButton = new FlxButton(FlxG.width - 110, 10, "Save Chart", () ->
		{
			try
			{
				var chart:String = Json.stringify(song);
				File.saveContent(Paths.chart(Paths.formatToSongPath(song.song)), chart);
				trace("chart saved!");
			}
			catch (e:Dynamic)
			{
				trace("Error while saving chart: " + e);
			}
		});
		add(saveButton);

		saveAsButton = new FlxButton(FlxG.width - 110, 40, "Save Chart As", saveSong);
		add(saveAsButton);

		copySectionButton = new FlxButton(FlxG.width - 110, 70, "Copy Section", () ->
		{
			notesCopied = [];
			sectionToCopy = curSection;
			for (i in 0...song.notes[curSection].sectionNotes.length)
				notesCopied.push(song.notes[curSection].sectionNotes[i]);
		});
		add(copySectionButton);

		pasteSectionButton = new FlxButton(FlxG.width - 110, 100, "Paste Section", () ->
		{
			if (notesCopied == null || notesCopied.length < 1)
				return;

			for (note in notesCopied)
			{
				var clonedNote = {
					noteStrum: note.noteStrum + Conductor.stepCrochet * (4 * 4 * (curSection - sectionToCopy)),
					noteData: note.noteData
				};
				song.notes[curSection].sectionNotes.push(clonedNote);
			}

			updateGrid();
		});
		add(pasteSectionButton);

		clearSectionButton = new FlxButton(FlxG.width - 110, 130, "Clear Section", () ->
		{
			song.notes[curSection].sectionNotes = [];
			updateGrid();
		});
		add(clearSectionButton);

		clearSongButton = new FlxButton(FlxG.width - 110, 160, "Clear Song", () ->
		{
			openSubState(new PromptSubState(Localization.get("youDecide"), () ->
			{
				for (daSection in 0...song.notes.length)
					song.notes[daSection].sectionNotes = [];
				updateGrid();
			}));
		});
		add(clearSongButton);

		loadSongButton = new FlxButton(FlxG.width - 110, 190, "Load Song", () -> openSubState(new LoadSongSubState()));
		add(loadSongButton);

		loadSongFromButton = new FlxButton(FlxG.width - 110, 220, "Load JSON", loadSongFromFile);
		add(loadSongFromButton);

		bpmInput = new FlxInputText(FlxG.width - 110, 280, 50);
		bpmInput.text = Std.string(song.bpm);
		add(bpmInput);

		setBPMButton = new FlxButton(FlxG.width - 110, 250, "Set BPM", setBPM);
		add(setBPMButton);

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + gridBG.width / 2, gridBG.y).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		strumLine = new FlxSprite(gridBG.x, 50).makeGraphic(Std.int(gridBG.width), 4);
		add(strumLine);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
