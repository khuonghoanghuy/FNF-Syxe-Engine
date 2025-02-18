package backend;

class TextHandler {
  public static function getText(fileName:String) {
    return parseContent(Assets.getText(Paths.data('$fileName.txt')));
  }

  public static function parseContent(content:String) {
    var data = {};
    var lines:Array<String> = content.split('\n');
    for (line in lines) {
      line.trim(line);
      if (line == null || line == "") {
        return null;
      }
      else if (line != null) {
        var sprIndex:Int = line.indexOf("::");
      var key:String = StringTools.trim(line.substr(0, sprIndex));
      var value:String = StringTools.trim(line.substr(sprIndex + 2));
              if (value.startsWith("{") && value.endsWith("}")) {
        try {
          data[key] = Json.parse(value);
        } catch (e:Dynamic) {
          throw 'Failed to parse JSON for key "$key": $e';
        }
      } else {
        data[key] = value;
      }
        return data;
    }
      }
    }
  }
}
