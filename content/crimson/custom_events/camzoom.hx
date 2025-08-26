var speed:Int = 4;
var zoom:Float = 1;

function onEvent(name:String, value1:String, value2:String):Void {
    if (name == "Cam Boom Speed") {
        speed = Std.parseInt(value1);
        zoom = Std.parseFloat(value2);
    }
}

function onBeatHit():Void {
    if (game.curBeat % speed == 0) {
        // This assumes you have access to camGame and camHUD directly
        camGame.zoom += 0.015 * zoom;
        camHUD.zoom += 0.03 * zoom;
    }
}