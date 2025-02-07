package;

import tjson.TJSON;

typedef StageDataJson = {
    dadPos:Array<Float>,
    dadCam:Array<Float>,

    gfPos:Array<Float>,
    gfCam:Array<Float>,
    
    bfPos:Array<Float>,
    bfCam:Array<Float>,

    defaultCamZoom:Float,
    cameraSpeed:Float
} 

class StageData
{
    public var stageJson:Dynamic;
    public var stageScript:HScript;

    public function new(stageFile:String) {
        stageJson = TJSON.parse(Paths.data("stages/" + stageFile + ".json"));

        stageScript = new HScript(Paths.data("stages/" + stageFile + ".hxs"));

        stageScript.set("dadPos", stageJson.dadPos);
        stageScript.set("dadCam", stageJson.dadCam);
        stageScript.set("gfPos", stageJson.gfPos);
        stageScript.set("gfCam", stageJson.gfCam);
        stageScript.set("bfPos", stageJson.bfPos);
        stageScript.set("bfCam", stageJson.bfCam);
        stageScript.set("defaultCamZoom", stageJson.defaultCamZoom);
        stageScript.set("cameraSpeed", stageJson.cameraSpeed);

        stageScript.execute();
    }
}