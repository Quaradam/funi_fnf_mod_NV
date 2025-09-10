import lime.app.Application;

var oldTitle = Application.current.window.title;

function onCreatePost() {
  Application.current.window.title = "Any Job Works - " + oldTitle;
}


function onLoad() {
  var bg = new BGSprite("anyjobworks/bg", -625, -125, 1, 1);
  bg.scale.set(1, 1);
  add(bg);
}
function onDestroy() {
  Application.current.window.title = oldTitle;
}