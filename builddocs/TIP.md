# TIP - another readme
These some tip/stuff i wanna say to these

## For Game
### Make/Add Sprite
Instead of using: 
```haxe
var sprite = new FlxSprite(0, 0, Paths.image('mySprite'));
add(sprite);
trace("Base :0");
```
Use the:
```haxe
FunkGame.quickAddSprite({
    // your args is here, for example:
    x: 0, y: 0, name: "mySprite",
    onlyLoad: true, image: "mySprite",
});
trace("Much Simpler :D");
```
However, for use `FunkGame.quickAddSprite`, is will add the variable onto the `FunkGame.mapVariableGame`, you can access the variable and adjust with the `cast`, for example: `cast(FunkGame.getVariable("mySprite"), FunkSprite).updateHitBox();` is still work tho :D