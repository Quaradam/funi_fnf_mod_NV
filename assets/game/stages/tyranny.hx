import funkin.states.substates.GameOverSubstate;
import flixel.tweens.FlxTween;
import lime.app.Application;

// QRDM was here too
var speed:Int = 4;
var zoom:Float = 1;
var lockCamera:Bool = false;
var go:FunkinVideoSprite;
var oldTitle = Application.current.window.title;


function startCountdown():Void {

}

function onSongStart() {
    camHUD.visible = false;
    lockCamera = true;
}

function onLoad() { //bg shot

    var sky = new BGSprite('tyranny/tyr-sky', -375, -250, 0.1, 0.1);
    sky.scale.set(1, 1);
    add(sky);

    var clouds = new BGSprite('tyranny/tyr-clouds', -375, -250, 0.2, 0.2);
    add(clouds);

    var mountain = new BGSprite('tyranny/tyr-moun', -350, -250, 0.4, 0.4);
    add(mountain);

    var hills = new BGSprite('tyranny/tyr-hills', -185, 130, 0.6, 0.6);
    hills.scale.set(0.75, 0.75);
    add(hills);

    var water = new FlxSprite(-500, -375);
    water.frames = Paths.getSparrowAtlas('tyranny/tyr-lake');
    water.animation.addByPrefix('dance', 'tyr-lake flow', 4, true);
    water.animation.play('dance');
    water.scrollFactor.set(0.8, 0.8);
    add(water);

    var flowers = new BGSprite('tyranny/tyr-flowers', -250, -450, 0.9, 0.9);
    flowers.scale.set(0.75, 0.75);
    add(flowers);

    var trees = new BGSprite('tyranny/tyr-trees', -150, -250, 0.95, 0.95);
    trees.scale.set(0.75, 0.75);
    add(trees);

    var ground = new BGSprite('tyranny/tyr-ground', -375, 700, 1, 1);
    add(ground);

    var pecky = new BGSprite('tyranny/tyr-body2', 900, 725, 1, 1);
    pecky.scale.set(0.75, 0.75);
    add(pecky);

    var flicky = new BGSprite('tyranny/tyr-body1', -375, 725, 1, 1);
    flicky.scale.set(0.75, 0.75);
    add(flicky);

    var pocky = new BGSprite('tyranny/tyr-body3', 500, 975, 1, 1);
    pocky.scale.set(0.75, 0.75);
    add(pocky);
    
    var grass = new BGSprite('tyranny/tyr-grass', -375, 700, 1, 1);
    grass.zIndex = 2;
    add(grass);

}


function onCreatePost() {
    Application.current.window.title = oldTitle + " - Tyranny";

    GameOverSubstate.deathSoundName = 'smtg/empty';
    GameOverSubstate.loopSoundName = 'smtg/empty';
    GameOverSubstate.endSoundName = 'smtg/empty';
    camHUD.alpha = 0;
    
}



function onBeatHit():Void {
    if (curBeat == 0) {
        camZooming = false;
        lockCamera = true;
        speed = 4;
        zoom = -1;
    }

    if (curBeat == 28) {
        camZooming = true;
        lockCamera = false;
        camHUD.visible = true;
        FlxTween.tween(camHUD,{alpha: 1}, 1.5, {ease: FlxEase.quadOut});
    }

    if (curBeat == 32) {
        speed = 1;
        zoom = 1.65;
    }

    if (curBeat == 96) {
        speed = 4;
        zoom = 1;
    }

    if (curBeat == 98){
        FlxTween.tween(camHUD,{alpha: 0}, 0.5, {ease: FlxEase.quadOut});
    }
    if (curBeat == 100) {
        camFollow.x = 200;
        camFollow.y = 320;
        speed = 1;
        zoom = 2;
    }

    if (curBeat == 104) {
         FlxTween.tween(camHUD,{alpha: 1}, 0.2, {ease: FlxEase.quadOut});
        speed = 1;
        zoom = 1.6;
    }

    if (curBeat == 232) {
        speed = 2.5;
        zoom = 1;
    }
    if (curBeat == 360) {
        speed = 1;
        zoom = 1.8;
    }

    if (curBeat % speed == 0) {
        camGame.zoom += 0.015 * zoom;
        camHUD.zoom += 0.03 * zoom;
    }
}

function onGameOverStart()
{
    var go = new FunkinVideoSprite();
    go.onFormat(() ->{
        go.setGraphicSize(0, FlxG.height);
        go.updateHitbox();
        go.screenCenter();
        go.cameras = [camOther];
    });
    go.load(Paths.video("kinofuge"));
    go.onEnd(() ->{
        FlxG.resetState();
    });
    go.play();
    GameOverSubstate.instance.add(go);
}

function onUpdatePost(elapsed:Float) {
   if (lockCamera) {
      camGame.zoom = 0.85;
      camHUD.zoom = 1;
   }
}

function onDestroy() {
    Application.current.window.title = oldTitle;
}