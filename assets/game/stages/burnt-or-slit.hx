import lime.app.Application;

var oldTitle = Application.current.window.title;
var speed:Int = 4;
var zoom:Float = 1;
var lockCamera:Bool = false;


var playerStrums:PlayField;
var opponentStrums:PlayField;





function onSongStart()
{
	camZooming = true;
	speed = 111111111111;
	zoom = 0.6;
	
}

function onLoad()
{
	var bg = new BGSprite("burntorslit/bos", 500, 300, 1, 1);
	bg.scale.set(3, 3);
	add(bg);
}

function onBeatHit()
{
	if (curBeat == 4)
	{
		
		speed = 4;
		zoom = 1;
	}
	
	if (curBeat >= 72 && curBeat < 72 + 4)
	{
		camHUD.flash(0xFF9F0000, 0.35);
		camGame.zoom = 1.7;
		camHUD.zoom = 1.4;
	}
	if (curBeat == 76)
	{
		speed = 1;
		zoom = 1.7;
	}
	
	if (curBeat % speed == 0)
	{
		camGame.zoom += 0.015 * zoom;
		camHUD.zoom += 0.03 * zoom;
	}
}



function onCreatePost()
{

	
	speed = 4;
	zoom = 1;

	botplayTxt.text = "BURNED OR SLIT";
	Application.current.window.title = oldTitle + " - Burnt or Slit";
	modManager.setValue('flip', 1);
  	modManager.setValue('opponentSwap', 0);
	modManager.setValue("unboundedReverse", 1);
	
}

function onStepHit()
{
	if (curStep == 2250)
	{
		FlxTween.tween(camHUD,{alpha: 0}, 2, {ease: FlxEase.cubicInOut});
	}
	if (curStep == 2268)
	{
		FlxTween.tween(camGame,{alpha: 0}, 2, {ease: FlxEase.cubicInOut});
	}
}





function onUpdatePost(elapsed:Float)
{
	if (lockCamera)
	{
		camGame.zoom = 0.65;
		camHUD.zoom = 1;
	}
}

function onDestroy()
{
	Application.current.window.title = oldTitle;
}
