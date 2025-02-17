package backend;

class CoolUtil {
    public static function genNumFromTo(from:Int, to:Int):Array<Int> {
        try {
            var daNum:Array<Int> = [];
            for (i in from...to + 1) {
                daNum.push(i);
            }
            return daNum;
        } catch (e) {
            trace("Catch Error: " + e.message);
            return [0];
        }
    }
}