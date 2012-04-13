(function() {
  var FieldScene, GAME_FPS, SCREEN_HEIGHT, SCREEN_WIDTH, TestScene, fieldScene, fireIntervalEvent, game, quicktigame2d, testScene, win;
  Ti.API.info("osname=" + Ti.Platform.osname);
  Ti.API.info("version=" + Ti.Platform.version);
  Ti.API.info("width=" + Ti.Platform.displayCaps.platformWidth);
  Ti.API.info("height=" + Ti.Platform.displayCaps.platformHeight);
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
  TestScene = require('testScene').testScene;
  testScene = new TestScene(game);
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
    game.start();
    return fireIntervalEvent('enterframe1');
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