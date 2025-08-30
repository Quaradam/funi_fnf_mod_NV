import flixel.FlxSprite;
import funkin.objects.BGSprite;

// QRDM was here
var speed:Int = 4;
var zoom:Float = 1;
var camZoomLock = false;


function onSongStart() {
	camZooming = true;
}

function onLoad(){
   
   var out = new BGSprite('fallentofakery/fake-outside', 0, 0, 1,1);
   out.scale.set(1, 1);
   add(out);

   var bg = new BGSprite('fallentofakery/fake-basement', 0, 0, 1, 1);
   bg.scale.set(1, 1);
   add(bg);
   var tv = new FlxSprite(0, 0);
   tv.frames = Paths.getSparrowAtlas('fallentofakery/fake-tv');
   tv.animation.addByPrefix('dance', 'fake-tv', 4, true);
   tv.animation.play('dance');
   tv.scale.set(1, 1);
   add(tv);

   var box = new BGSprite('fallentofakery/fake-boxes', 0, 0, 1, 1);
   box.scale.set(1, 1);
   add(box);

   var plush = new BGSprite('fallentofakery/fake-merch', 0, 0, 1, 1);
   plush.scale.set(1, 1);
   add(plush);

   var ovly = new BGSprite('fallentofakery/fake-overlay', 0, 0, 1, 1);
   ovly.scale.set(1, 1);
   add(ovly);
}

function onMoveCamera(whosTurn){
    if (camZoomLock) return;

    if(whosTurn == "dad")
        defaultCamZoom = 1.5;
    else
        defaultCamZoom = 1;
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