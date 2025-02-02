package;

class StageData extends HScript
{
    public function new(stageFile:String) {
        super(Paths.data('stages/${stageFile}.hxs'));
    }    
}