
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;
import funkin.objects.BGSprite;
import openfl.filters.ShaderFilter;
import lime.app.Application;

// QRDM was here
var lockCamera:Bool = false;
var speed:Int = 4;
var zoom:Float = 1;
var camZoomLock = false;
var text:FlxText;
var zoomTween:FlxTween = null;

// Helper object for camera zoom tweening
var zoomObject = {zoom: 1.0};

var oldTitle = Application.current.window.title;
var titleTimer:Float = 0;
var titleUpdateSpeed:Float = 0.05;
var possibleChars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()";
var isAnimating:Bool = true;
var revealBeat:Int = 8;
var finalText:String = "Fallen to Fakery";
var revealedChars:Int = 0;
var charsPerBeat:Int = 2; // How many characters to reveal per beat // Change this to the beat where you want the text to stop scrambling

var shader = newShader("warp");
//var chromatic = newShader("chrom");
//var f2 = new ShaderFilter(chromatic);
shader.setFloat("warp", 1.75);
var f1 = new ShaderFilter(shader);


function onSongStart() {
	camZooming = true;
   camGame.angle = 0;
   speed = 11111111;
   zoom = 1;

}

function onCreatePost(){
   camGame.filters = [f1];
   camHUD.filters = [f1];

   skipCountdown = true;

   
   camHUD.zoom = 0.9;
   camHUD.alpha = 1;
   defaultHudZoom = 0.9;

   text = new FlxText();
   text.text = 'FALLEN TO FAKERY';
   text.setFormat(Paths.font("sonic2HUD.ttf"), 64, 0xFFFF0000, FlxTextAlign.CENTER);
   text.cameras = [camOther];
   text.screenCenter();
   text.alpha = 0;
   add(text);

   healthBar.angle = 90;
   healthBar.x = FlxG.width - healthBar.width - 900;
   healthBar.y = FlxG.height / 2.1 - healthBar.height / 2.1;
   
   iconP1.x = healthBar.x;
   iconP1.y = healthBar.y;
   iconP2.x = healthBar.x;
   iconP2.y = healthBar.y;

   modManager.setValue("tipsy", 0.3);
   modManager.setValue('reverse', 1, 0);
   modManager.setValue('alpha', 0, 0);
   modManager.setValue('opponentSwap', 1);
}

function getRandomChar() {
    return possibleChars.charAt(Math.floor(Math.random() * possibleChars.length));
}

function getScrambledText(length:Int) {
    var scrambled = "";
    for (i in 0...length) {
        scrambled += getRandomChar();
    }
    return scrambled;
}

function onUpdate(elapsed:Float) {
    if (isAnimating) {
        titleTimer += elapsed;
        
        // Update scrambled text at regular intervals
        if (titleTimer % titleUpdateSpeed < 0.016) { // 0.016 is roughly one frame
            var scrambledText = getScrambledText(15); // Length of "Fallen to Fakery"
            Application.current.window.title = oldTitle + " - " + scrambledText;
        }
    }
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
   tv.animation.addByPrefix('dance', 'fake-tv', 24, true);
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

function getMixedText() {
    var result = "";
    // Add revealed characters
    for (i in 0...finalText.length) {
        if (i < revealedChars) {
            result += finalText.charAt(i);
        } else {
            result += getRandomChar();
        }
    }
    return result;
}

function onStepHit(){
   //heath -= 0.005;
   if (curStep % revealBeat == 0 && isAnimating) {
      revealedChars += charsPerBeat;
      if (revealedChars >= finalText.length) {
         revealedChars = finalText.length;
         isAnimating = false;
      }
      Application.current.window.title = oldTitle + " - " + getMixedText();
   }
}

function onBeatHit():Void {

   //if (curBeat % 4 == 0) {
     // FlxTween.tween(FlxG.camera, {angle: -10}, 0.6, {ease: FlxEase.sineInOut});
   //}


   if (curBeat == 0) {
      speed = 4;
      zoom = 1;
   }
   if (curBeat == 16) {
      //modManager.setValue('tipsySpeed', 5);

     speed = 1;
     zoom = 1.3;
     defaultHudZoom = 0.9;
     defaultCamZoom = 1.2;
     isAnimating = false;
     revealedChars = finalText.length;
     Application.current.window.title = oldTitle + " - " + finalText;
   }
   if (curBeat == 80) {
      camZooming = true;
      FlxTween.tween(camHUD,{alpha: 0}, 0.7, {ease: FlxEase.quadOut});
      //FlxTween.tween(camGame,{zoom: 1.9}, 8, {ease: FlxEase.quadOut});

      FlxTween.tween(FlxG.camera, {zoom: 2}, 8);
      speed = 111111111;
      zoom = 1;
   }
   if (curBeat == 95) {
      camZooming = true;
      FlxTween.tween(camHUD,{alpha: 1}, 0.7, {ease: FlxEase.quadOut});
      lockCamera = false;
      defaultCamZoom = 1.2;
      speed = 1;
      zoom = 1.4;
   }
   if (curBeat == 420) {
      modManager.setValue('tipsy', 0.5, 3);
      FlxTween.tween(camHUD,{alpha: 0}, 0.7, {ease: FlxEase.quadOut});
      FlxTween.tween(camGame, {alpha: 0}, 1.3, {ease: FlxEase.quadOut});
      FlxTween.tween(camGame, {zoom: 12}, 10, {ease: FlxEase.quadOut});
   }
   // Smooth transition examples
   if (curBeat == 288) {
      //Scroll Change
      modManager.setValue('reverse', 1, 1);
      FlxTween.num(1, 0, 1.5, {ease: FlxEase.sineInOut}, function(value:Float) {
         modManager.setValue('reverse', value, value);
      }); // Smoothly transition to downscroll over 1.5 seconds
      // Opponent swap
      modManager.setValue('opponentSwap', 0.5);
      FlxTween.num(1, 0.5, 1.2, {ease: FlxEase.quartInOut}, function(value:Float) {
         modManager.setValue('opponentSwap', value);
      }); // Smoothly enable over 1 second
      //Alpha
      modManager.setValue('alpha', 0, 0); // Set initial alpha
      FlxTween.num(0, 0.82, 2, {ease: FlxEase.sineInOut}, function(value:Float) {
         modManager.setValue('alpha', value, 1);
      }); // Smoothly fade to 0.5 over 2 seconds
   }
   if (curBeat == 320) {

      modManager.setValue('reverse', 0, 0);
      FlxTween.num(0, 0, 1.5, {ease: FlxEase.sineInOut}, function(value:Float) {
         modManager.setValue('reverse', value, value);
      }); // Smoothly transition back to upscroll over 1.5 seconds

      modManager.setValue('opponentSwap', 1);
      FlxTween.num(0.5, 0, 1.2, {ease: FlxEase.quartInOut}, function(value:Float) {
         modManager.setValue('opponentSwap', value);
      });

      modManager.setValue('alpha', 1, 1);
      FlxTween.num(1, 0, 1, {ease: FlxEase.sineInOut}, function(value:Float) {
         modManager.setValue('alpha', value, 1);
      }); // Smoothly return to full alpha over 1 second
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
function onDestroy() {
   	Application.current.window.title = oldTitle;
}