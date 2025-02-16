package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.*;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import tjson.TJSON;

typedef TitleData = {
    gfPos:Array<Float>,
    titlePos:Array<Float>,
    logoPos:Array<Float>,
    loadScript:String
}

class TitleState extends MusicBeatState
{
    public static var initialized:Bool = false;
    var skippedIntro:Bool = false;
    public static var beatCamera:Bool = false;
    public static var doneCameraFlash:Bool = false;

    var gfDance:FlxSprite;
    var titleText:FlxSprite;
    var logoBl:FlxSprite;
    var afterIntroGroup:FlxSpriteGroup;
    var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
    var ngSpr:FlxSprite;

    var curWacky:Array<String> = [];

    var danceLeft:Bool = false;
    var titleData:TitleData;

    override function create() {
        super.create();

        titleData = TJSON.parse(Assets.getText(Paths.data("titleJson.json")));
        FlxG.game.focusLostFramerate = 60;
        FlxG.save.bind("SyxeEngineData", "Huy1234TH");
        HighScore.load();

        curWacky = FlxG.random.getObject(getIntroTextShit());

        new FlxTimer().start(1, function (timer:FlxTimer) {
            startIntro(); 
        });
    } 

    function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.data('introText.txt'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

    function startIntro() {
		if (!initialized)
        {
            var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
            diamond.persist = true;
            diamond.destroyOnNoUse = false;

            FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
                new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
            FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
                {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        }

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu/freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

        Conductor.changeBPM(102);
        persistentUpdate = true;

        afterIntroGroup = new FlxSpriteGroup();
        afterIntroGroup.visible = skippedIntro;
        add(afterIntroGroup);

		if (titleData.logoPos != null)
            logoBl = new FlxSprite(titleData.logoPos[0], titleData.logoPos[1]);
        else
            logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
        afterIntroGroup.add(logoBl);

        gfDance = new FlxSprite(titleData.gfPos[0], titleData.gfPos[1]);
        gfDance.frames = Paths.getSparrowAtlas("gfDanceTitle");
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
        gfDance.updateHitbox();
        afterIntroGroup.add(gfDance);

        titleText = new FlxSprite(titleData.titlePos[0], titleData.titlePos[1]);
        titleText.frames = Paths.getSparrowAtlas("titleEnter");
        titleText.animation.addByPrefix("idle", "Press Enter to Begin");
        titleText.animation.addByPrefix("pressed", "ENTER PRESSED");
        titleText.animation.play("idle");
        titleText.updateHitbox();
        afterIntroGroup.add(titleText);

        ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
        add(ngSpr);

        credGroup = new FlxGroup();
        add(credGroup);

        textGroup = new FlxGroup();
        add(textGroup);

        initialized = true;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

        if (Controls.justPressed("accept") && !skippedIntro && initialized)
            skippedIntroPls();

        if (FlxG.keys.justReleased.ENTER && skippedIntro && initialized)
        {
            if (doneCameraFlash) {
                camera.flash(FlxColor.WHITE, 1, function () {
                    FlxG.switchState(MainMenuState.new);
                });
            }
        }

        camera.zoom = FlxMath.lerp(1, camera.zoom, 0.95);
    }

    override function beatHit() {
        super.beatHit();

        danceLeft = !danceLeft;
        if (gfDance != null && gfDance.animation != null) {
            gfDance.animation.play((danceLeft ? "danceLeft" : "danceRight"));
        }
        logoBl.animation.play("bump");

        if (beatCamera) {
            if (curBeat % 4 == 0)
                camera.zoom += 0.025;
        }

        switch (curBeat) {
            case 1:
                createCoolText(['huy1234th']);
            case 3:
                addMoreText('present');
            case 4:
                deleteCoolText();
            case 5:
                createCoolText(['Not association', 'with']);
            case 7:
                addMoreText('newgrounds');
                ngSpr.visible = true;
            case 8:
                deleteCoolText();
                ngSpr.visible = false;
            case 9:
                createCoolText([curWacky[0]]);
            case 11:
                addMoreText(curWacky[1]);
            case 12:
                deleteCoolText();
            case 13:
                addMoreText('Friday');
            case 14:
                addMoreText('Night');
            case 15:
                addMoreText('Funkin');
            case 16:
                skippedIntroPls();
        }
    }

    function createCoolText(textArray:Array<String>)
    {
        for (i in 0...textArray.length)
        {
            var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
            money.screenCenter(X);
            money.y += (i * 60) + 200;
            credGroup.add(money);
            textGroup.add(money);
        }
    }

    function addMoreText(text:String)
    {
        var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
        coolText.screenCenter(X);
        coolText.y += (textGroup.length * 60) + 200;
        credGroup.add(coolText);
        textGroup.add(coolText);
    }

    function deleteCoolText()
    {
        while (textGroup.members.length > 0)
        {
            credGroup.remove(textGroup.members[0], true);
            textGroup.remove(textGroup.members[0], true);
        }
    }

    function skippedIntroPls() {
        if (!skippedIntro) {
            remove(credGroup);
            remove(textGroup);
            remove(ngSpr);
            afterIntroGroup.visible = true;
            camera.flash(FlxColor.WHITE, 2, function () {
                doneCameraFlash = true;
            });
            skippedIntro = true;
            doSomeExtraFunni();
        }
    }
    
    function doSomeExtraFunni() {
        afterIntroGroup.y = 500;
        FlxTween.cancelTweensOf(afterIntroGroup);
        FlxTween.tween(afterIntroGroup, {y: 0}, 4, {ease: FlxEase.sineInOut, onComplete: function (tween:FlxTween) {
            beatCamera = true;
        }});
    }
}