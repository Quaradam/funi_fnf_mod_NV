var allowedToBop:Bool = true;
var beatPerZoom:Int = 1;

function onBeatHit(){ //bpm zoom cam bombom (thx internet and devs that using hx/hxs files i can see what u did, and i gave big respect to ya'll)
   	
    if (game.curBeat >= 0 && game.curBeat < 32 && game.curBeat % 0 == 1) {
	}

    if (game.curBeat % beatPerZoom == 0 && allowedToBop) {
		game.camGame.zoom += 0.015 * game.camZoomingMult;
		game.camHUD.zoom += 0.03 * game.camZoomingMult;
	}
}