// QRDM was here
var speed:Int = 4;
var zoom:Float = 1;


function onSongStart() {
	camZooming = true;
}

function onLoad(){
   var bg = new BGSprite('fallentofakery/bg', 0, 0, 1, 1);
   bg.scale.set(2.1, 2.1);
   add(bg);
}

function onBeatHit():Void {
   if (curBeat == 0) {
     speed = 4;
     zoom = 1;
   }
   if (curBeat == 16) {
     speed = 1;
     zoom = 1.3;
   }
   if (curBeat % speed == 0) {
      camGame.zoom += 0.015 * zoom;
      camHUD.zoom += 0.03 * zoom;
   }
}