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
   bg.scrollFactor.set(1, 1);
   bg.scale.set(1, 1);
   add(bg);
}

function onCreatePost() {
   vedeo = new FunkinVideoSprite();
   vedeo.onFormat(()->{
      vedeo.setGraphicSize(0, 0);
      vedeo.scale.set(1, 1);
      vedeo.updateHitbox();
      vedeo.screenCenter();
      vedeo.cameras = [camGame];
   });
   vedeo.load(Paths.video('pi'), [FunkinVideoSprite, FunkinVideoSprite.looped]);
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
