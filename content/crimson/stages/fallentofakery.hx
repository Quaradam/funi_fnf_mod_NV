import flixel.text.FlxText;

var text:FlxText;
var beatPerZoom:Int = 4;
var allowedToBop:Bool = true;

function onSongStart() {
	camZooming = true;
}

function onLoad(){
   var bg = new BGSprite('fallentofakery/bg', 0, 0, 1, 1);
   bg.scale.set(2.1, 2.1);
   add(bg);
}
function onCreatePost(){
   text = new FlxText(0, 0, 0, '-10-', 50);
   text.setFormat(Paths.font("MGS2.otf"), 50, FlxColor.WHITE);
   add(text);
}
function onBeatHit(){
   var beatPerZoom: Int = 1;
	if (game.curBeat % beatPerZoom == 0 && allowedToBop) {
		//debugPrint('booped');
		game.camGame.zoom += 0.015 * game.camZoomingMult;
		game.camHUD.zoom += 0.03 * game.camZoomingMult;
	}
}