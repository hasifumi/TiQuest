(function() {
  var FieldScene, GAME_FPS, SCREEN_HEIGHT, SCREEN_WIDTH, fieldScene, fireIntervalEvent, game, quicktigame2d, win;
  SCREEN_WIDTH = 320;
  SCREEN_HEIGHT = 480;
  GAME_FPS = 30;
  win = Ti.UI.createWindow({
    backaroudColor: 'red'
  });
  quicktigame2d = require('com.googlecode.quicktigame2d');
  game = quicktigame2d.createGameView();
  game.fps = GAME_FPS;
  game.color(1, 1, 1);
  game.debug = true;
  game.frame = 0;
  FieldScene = require('fieldScene').fieldScene;
  fieldScene = new FieldScene(game);
  game.addEventListener('onload', function(e) {
    var WINDOW_SCALE_FACTOR_X, WINDOW_SCALE_FACTOR_Y, screenScale;
    screenScale = game.width / 320;
    game.screen = {
      width: game.width / screenScale,
      height: game.height / screenScale
    };
    WINDOW_SCALE_FACTOR_X = game.screen.width / game.width;
    WINDOW_SCALE_FACTOR_Y = game.screen.height / game.height;
    game.pushScene(fieldScene);
    return game.start();
  });
  fireIntervalEvent = function(event) {
    return setInterval(function() {
      return game.fireEvent(event);
    }, 1000 / game.fps);
  };
  win.add(game);
  return win.open({
    fullscreen: true,
    navBarHidden: true
  });
})();