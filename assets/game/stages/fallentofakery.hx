
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;
import funkin.objects.BGSprite;
import openfl.filters.ShaderFilter;

// QRDM was here
var lockCamera:Bool = false;
var speed:Int = 4;
var zoom:Float = 1;
var camZoomLock = false;
var text:FlxText;


var shader = newShader("warp");
shader.setFloat("warp", 1.75);
var f1 = new ShaderFilter(shader);

function onSongStart() {
	camZooming = true;
}

function onCreatePost(){
   camGame.filters = [f1];
   camHUD.filters = [f1];

   camHUD.zoom = 0.9;
   camHUD.alpha = 1;
   defaultHudZoom = 0.9;

   text = new FlxText();
   text.text = 'FALLEN TO FAKERY';
   text.setFormat(Paths.font("vcr.ttf"), 64, 0xFFFFFFFF, FlxTextAlign.CENTER);
   text.cameras = [camOther];
   text.screenCenter();
   text.alpha = 0;
   add(text);
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

   var ovly:FlxSprite = new FlxSprite().loadGraphic(Paths.image('fallentofakery/fake-overlay'));
   ovly.cameras = [camHUD];
   ovly.scale.set(1.1, 1.1);
   add(ovly);
}

function onMoveCamera(whosTurn){
    if (camZoomLock) return;

    if(whosTurn == "dad")
        defaultCamZoom = 1.128;
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
   if (curBeat == 80) {
      camZooming = false;
      lockCamera = true;     
      FlxTween.tween(camHUD,{alpha: 0}, 0.7, {ease: FlxEase.quadOut});
      defaultCamZoom = 0.9;
   }
   if (curBeat == 95) {
      camZooming = true;
      FlxTween.tween(camHUD,{alpha: 1}, 0.7, {ease: FlxEase.quadOut});
      lockCamera = false;
      speed = 1;
      zoom = 1.4;
   }
   if (curBeat == 420) {
      FlxTween.tween(camHUD,{alpha: 0}, 0.7, {ease: FlxEase.quadOut});
   }

   if (curBeat % speed == 0) {
      camGame.zoom += 0.015 * zoom;
      camHUD.zoom += 0.03 * zoom;
   }
}

function onEvent(name:String, val1:String, val2:String) {
   if (name == ''){
      if (val1 == 'showText') { 
         camOther.filters = [f1];
         camHUD.filters = [f1];
            FlxTween.tween(text, {alpha: 1}, 2.5, {ease: FlxEase.quadOut,onComplete: function (f) {
            FlxTween.tween(text, {alpha: 0}, 1, {ease: FlxEase.quadOut, startDelay: 1});
            }});
      }
   }
}
function onUpdatePost(elapsed:Float) {
   if (lockCamera) {
      camGame.zoom = 0.9;
      camHUD.zoom = 0.9;
   }
}