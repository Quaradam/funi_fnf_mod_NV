import lime.app.Application;

var oldTitle = Application.current.window.title;

function onLoad() {
  var bg = new BGSprite("burntorslit/bos", 500, 300, 1, 1);
  bg.scale.set(3, 3);
  add(bg);
}
function onCreatePost() {
  Application.current.window.title = "Burnt or Slit - " + oldTitle;
}
function onDestroy() {
  Application.current.window.title = oldTitle;
}