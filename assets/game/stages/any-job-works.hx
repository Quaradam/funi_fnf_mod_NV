import lime.app.Application;

var oldTitle = Application.current.window.title;

function onCreatePost()
{
	Application.current.window.title = oldTitle + " - Any Job Works";
	//modManager.setValue('bumpy', 0.03);

	botplayTxt.text = "i think i can do any job here... yes??";
	
	modManager.queueEase(101, 102, 'squish', 1, 'circInOut');
	modManager.queueEase(101, 102, 'alpha', 1, 'quadOut', 1);
	modManager.queueEase(102, 103, 'squish', 0, 'circInOut');
	modManager.queueEase(101, 103, 'transform0X', -300, 'quadOut');
	modManager.queueEase(101, 103, 'transform1X', -300, 'quadOut');
	modManager.queueEase(101, 103, 'transform2X', -300, 'quadOut');
	modManager.queueEase(101, 103, 'transform3X', -300, 'quadOut');
	modManager.queueEase(98, 104, 'rotateX', 6.28, 'quadOut');
	// modManager.queueEase(97, 104, "rotate", 180, 'quadInOut');
}

function onLoad()
{
	var bg = new BGSprite("anyjobworks/bg", -625, -125, 1, 1);
	bg.scale.set(1, 1);
	add(bg);
}

function onStepHit()
{
	if (curStep == 101)
	{
		defaultHUDZoom = 0.75;
		camGame.shake(0.015, 0.3);
	}
}

function onDestroy()
{
	Application.current.window.title = oldTitle;
}
