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
var spinArray:Array<Int>;
var finale:Bool = false;
var normal:Bool = false;
var midsong:Bool = false;

var weedSpinningTime:Bool = false;


var playerStrums:PlayField;
var opponentStrums:PlayField;

// icons
var iconP1:HealthIcon;
var iconP2:HealthIcon;

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
//
var shader = newShader("warp");

// var chromatic = newShader("chrom");
// var f2 = new ShaderFilter(chromatic);
shader.setFloat("warp", 1.75);
var f1 = new ShaderFilter(shader);

function onSongStart()
{
	camGame.filters = [f1];
	camHUD.filters = [f1];
	camZooming = true;
	camGame.angle = 0;
	speed = 11111111;
	zoom = 1;
}

function onCreatePost()
{
	camGame.filters = [f1];
	camHUD.filters = [f1];
	
	skipCountdown = true;
	
	

	camHUD.zoom = 0.9;
	camHUD.alpha = 1;
	defaultHudZoom = 0.9;
	
	botplayTxt.text = 'Fallen to FAKE SONIC';

	text = new FlxText();
	text.text = 'FALLEN TO FAKERY';
	text.setFormat(Paths.font("sonic2HUD.ttf"), 64, 0xFFFF0000, FlxTextAlign.CENTER);
	text.cameras = [camOther];
	text.screenCenter();
	text.alpha = 0;
	add(text);
	
	
	
	
	// modManager.setValue("split", 1);
	modManager.setValue("centered", 0);
	modManager.setValue("drunk", 0.75);
	modManager.setValue("drunkOffset", 100);
	modManager.setValue("drunkSpeed", 0.15);
	modManager.setValue("drunkPeriod", -1);
	modManager.setValue("tipsy", 0.5);
	modManager.setValue('reverse', 1, 0);
	modManager.setValue('alpha', 0);
	modManager.setValue('opponentSwap', 1);
	
	

	modManager.queueEase(1399, 1408, 'drunk', 1.45, 'sineInOut');
	modManager.queueEase(1399, 1405, 'transform0X', -1000, 'bounceIn', 1);
	modManager.queueEase(1399, 1405, 'transform1X', -1000, 'bounceIn', 1);
	modManager.queueEase(1399, 1405, 'transform2X', -1000, 'bounceIn', 1);
	modManager.queueEase(1399, 1405, 'transform3X', -1000, 'bounceIn', 1);
	modManager.queueEase(1399, 1405, 'transform0X', -300, 'bounceIn', 0);
	modManager.queueEase(1399, 1405, 'transform1X', -300, 'bounceIn', 0);
	modManager.queueEase(1399, 1405, 'transform2X', -300, 'bounceIn', 0);
	modManager.queueEase(1399, 1405, 'transform3X', -300, 'bounceIn', 0);
	modManager.queueEase(1399, 1400, 'squish', 0.75, 'bounceIn');
	modManager.queueEase(1400, 1404, 'squish', 0, 'quintOut');
	
	modManager.queueSet(1399, 'drunkOffset', 1);
	modManager.queueSet(1400, 'drunkSpeed', 1);

	
}

function numericForInterval(start, end, interval, func){
    var index = start;
    while(index < end){
        func(index);
        index += interval;
    }
}


function getRandomChar()
{
	return possibleChars.charAt(Math.floor(Math.random() * possibleChars.length));
}

function getScrambledText(length:Int)
{
	var scrambled = "";
	for (i in 0...length)
	{
		scrambled += getRandomChar();
	}
	return scrambled;
}

function onUpdate(elapsed:Float)
{
	if (isAnimating)
	{
		titleTimer += elapsed;
		
		// Update scrambled text at regular intervals
		if (titleTimer % titleUpdateSpeed < 0.016)
		{ // 0.016 is roughly one frame
			var scrambledText = getScrambledText(15); // Length of "Fallen to Fakery"
			Application.current.window.title = oldTitle + " - " + scrambledText;
		}
	}
	if (!finale)
	{
		if (normal)
		{
			defaultCamZoom = 0.9;
		}
		else
		{
			if (PlayState.SONG.notes[curSection].mustHitSection) defaultCamZoom = 1;
			else defaultCamZoom = 1.128;
		}
		if (midsong)
		{
			if (PlayState.SONG.notes[curSection].mustHitSection) defaultCamZoom = 1.35;
			else defaultCamZoom = 1.15;
		}
		else
		{
			if (PlayState.SONG.notes[curSection].mustHitSection) defaultCamZoom = 0.9;
			else defaultCamZoom = 1.128;
		}
	}
}

function onLoad()
{
	var out = new BGSprite('fallentofakery/fake-outside', 0, 0, 1, 1);
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
	ovly.cameras = [camOther];
	ovly.alpha = 1;
	ovly.scale.set(1.1, 1.1);
	add(ovly);
}


function getMixedText()
{
	var result = "";
	for (i in 0...finalText.length)
	{
		if (i < revealedChars)
		{
			result += finalText.charAt(i);
		}
		else
		{
			result += getRandomChar();
		}
	}
	return result;
}

function onStepHit()
{
	
	if (curStep == 1)
	{
		normal = true;
		speed = 1111111111111111;
		zoom = 1;
	}
	if (curStep == 1600){
		modManager.queueEase(1600, 1680, 'tipsy', 1, 'bounceInOut');
	}
	if (curStep == 1663)
	{
		finale = true;
		camGame.shake(0.015, 3.7);
		camHUD.shake(0.015, 3.7);
	}
	if (curStep % revealBeat == 0 && isAnimating)
	{
		revealedChars += charsPerBeat;
		if (revealedChars >= finalText.length)
		{
			revealedChars = finalText.length;
			isAnimating = false;
		}
		Application.current.window.title = oldTitle + " - " + getMixedText();
	}
}

function onBeatHit():Void
{
	
	if (curBeat == 0)
	{
		normal = true;
		speed = 4;
		zoom = 1;
	}
	if (curBeat == 16)
	{
		normal = false;
		speed = 1;
		zoom = 1.3;
		isAnimating = false;
		revealedChars = finalText.length;
		Application.current.window.title = oldTitle + " - " + finalText;
	}
	if (curBeat == 80)
	{
		camZooming = true;
		FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.quadOut});
		
		FlxTween.tween(FlxG.camera, {zoom: 2}, 7.9, {ease: FlxEase.linearInOut});
		speed = 111111111;
		zoom = 1;
	}
	if (curBeat == 95)
	{
		camZooming = true;
		
		FlxTween.tween(camHUD, {alpha: 1}, 0.7, {ease: FlxEase.quadOut});
		lockCamera = false;
		speed = 1;
		zoom = 1.4;
	}
	if (curBeat == 420)
	{
		modManager.setValue('tipsy', 0.5, 3);
		FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.quadOut});
		FlxTween.tween(camGame, {alpha: 0}, 1.3, {ease: FlxEase.quadOut});
		FlxTween.tween(camGame, {zoom: 12}, 10, {ease: FlxEase.quadOut});
	}
	// Smooth transition examples
	if (curBeat == 288)
	{
		midsong = true;
		// Scroll Change
		modManager.queueEase(1151, 1166, 'reverse', 1, 'sineInOut', 1);
		modManager.queueEase(1151, 1166, 'reverse', 0, 'sineInOut', 0);
		// Opponent swap
		modManager.queueEase(1151, 1166, 'opponentSwap', 0.5, 'quartInOut');
		// Alpha
		modManager.queueEase(1151, 1166, 'alpha', 0.75, 'sineInOut', 1);
	}
	if (curBeat == 320)
	{
		modManager.queueEase(1191, 1206, 'reverse', 1, 'quadInOut', 1);
		modManager.queueEase(1191, 1206, 'reverse', 0, 'quadInOut', 0);
		modManager.queueEase(1279, 1292, 'opponentSwap', 0, 'quadInOut');
		modManager.queueEase(1279, 1292, 'alpha', 0, 'quadInOut', 1);

		midsong = false;
	}
	
	if (curBeat % speed == 0)
	{
		camGame.zoom += 0.015 * zoom;
		camHUD.zoom += 0.03 * zoom;
	}
}

function onEvent(name:String, val1:String, val2:String)
{
	if (name == '')
	{
		if (val1 == 'showText')
		{
			camOther.filters = [f1];
			camHUD.filters = [f1];
			FlxTween.tween(text, {alpha: 1}, 2.5,
				{
					ease: FlxEase.quadOut,
					onComplete: function(f) {
						FlxTween.tween(text, {alpha: 0}, 1, {ease: FlxEase.quadOut, startDelay: 1});
					}
				});
		}
	}
}

function onUpdatePost(elapsed:Float)
{
	if (lockCamera)
	{
		camGame.zoom = 0.9;
		camHUD.zoom = 0.9;
	}
}

function onDestroy()
{
	Application.current.window.title = oldTitle;
}
