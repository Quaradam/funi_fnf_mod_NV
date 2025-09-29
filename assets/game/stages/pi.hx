var vedeo:FunkinVideoSprite;

function onDestroy() {
   if (vedeo != null) vedeo.destroy();
}

function onSongStart() {
   vedeo.play();

   dad.visible = false;
   boyfriend.visible = false;
   gf.visible = false;
}

function onLoad() {
   var bg = new FlxSprite().loadGraphic(Paths.image('pi/bg'));
   bg.scrollFactor.set(1.5, 1.5);
   bg.scale.set(1.9, 1.9);
   add(bg);
}

function onCreatePost() {

    modManager.setValue('alpha', 1, 1);
    modManager.setValue('opponentSwap', 0);

   vedeo = new FunkinVideoSprite();
   vedeo.onFormat(()->{
      vedeo.setGraphicSize(0, 0);
      vedeo.updateHitbox();
      vedeo.screenCenter();
      vedeo.cameras = [camHUD];
   });
   vedeo.load(Paths.video('pi'), [FunkinVideoSprite.muted]);
   vedeo.visible = true;
   add(vedeo);
   skipCountdown = true;
   for (note in notes) {
    note.visible = true;
    note.alpha = 1;
   }
   for (strum in playerStrums) {
    strum.visible = true;
    strum.alpha = 1;
   }
}
