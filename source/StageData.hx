package;

class StageData
{
    public var stageScript:HScript;
    public function new(stageFile:String) {
        stageScript = new HScript(Paths.data("stages/" + stageFile + ".hxs"));
        stageScript.execute();
    }
}