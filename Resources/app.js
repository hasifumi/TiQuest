var GAME_FPS, Map, Pad, Player, SCREEN_HEIGHT, SCREEN_WIDTH, TestScene, WINDOW_SCALE_FACTOR_X, WINDOW_SCALE_FACTOR_Y, clearMaps, fireIntervalEvent, game, label1, map, mapjson, maps, nextMapX, nextMapY, nextPlayerX, nextPlayerY, pad, player, quicktigame2d, scene, testScene, updateMaps, updatePad, view1, win;
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
scene = quicktigame2d.createScene();
scene.color(1, 1, 1);
TestScene = require('testScene').testScene;
testScene = new TestScene(game);
maps = [];
mapjson = "";
Map = require('map').Map;
clearMaps = function(_maps) {
  var i, _i, _len;
  for (_i = 0, _len = _maps.length; _i < _len; _i++) {
    i = _maps[_i];
    scene.remove(i);
    i = null;
  }
  return _maps = [];
};
updateMaps = function(_mapfile, _maps, _mapjson) {
  var i, mapfile, _i, _len, _map, _ref, _results;
  setTimeout(function() {
    return Ti.API.debug("Sleep 3 sec.");
  }, 3000);
  mapfile = Ti.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory, _mapfile);
  mapjson = JSON.parse(mapfile.read().toString());
  _mapjson = mapjson;
  _ref = mapjson.layers;
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(mapjson.layers[_i].type === 'tilelayer' ? (_map = new Map(_mapfile, _i), _maps.push(_map), _maps[_i].z = _i, scene.add(_maps[_i]), _i === 0 ? (_maps[_i].loadCollisionData(), _maps[_i].loadDoorData()) : void 0) : void 0);
  }
  return _results;
};
updateMaps('graphics/map/map001.json', maps, mapjson);
map = maps[0];
Player = require('player').Player;
player = new Player();
Pad = require('pad').Pad;
pad = new Pad();
pad.color(1, 0, 0);
player.z = 10;
pad.z = 20;
scene.add(player);
scene.add(pad);
WINDOW_SCALE_FACTOR_X = 1;
WINDOW_SCALE_FACTOR_Y = 1;
nextPlayerX = 0;
nextPlayerY = 0;
nextMapX = 0;
nextMapY = 0;
player.isMoving = false;
game.pushScene(testScene);
game.addEventListener('onload', function(e) {
  var screenScale;
  screenScale = game.width / 320;
  game.screen = {
    width: game.width / screenScale,
    height: game.height / screenScale
  };
  WINDOW_SCALE_FACTOR_X = game.screen.width / game.width;
  WINDOW_SCALE_FACTOR_Y = game.screen.height / game.height;
  Ti.API.info("game.width=" + game.width);
  Ti.API.info("game.height=" + game.height);
  Ti.API.info("screenScale=" + screenScale);
  Ti.API.info("game.screen.width=" + game.screen.width);
  Ti.API.info("game.screen.height=" + game.screen.height);
  pad.y = game.screen.height - pad.height;
  game.start();
  Ti.API.info("player.x=" + player.x + ",y=" + player.y);
  Ti.API.info("pad.x=" + pad.x + ",y=" + pad.y);
  Ti.API.info("map.x=" + map.x + ",y=" + map.y);
  return fireIntervalEvent('enterframe1');
});
game.addEventListener('enterframe1', function(e) {
  var doorTest;
  game.frame++;
  updatePad();
  if (player.isMoving === false) {
    doorTest = map.isDoor(player.x, player.y);
    if (doorTest) {
      if (mapjson.doors[doorTest - 1].toMapfile != null) {
        clearMaps(maps);
        maps = [];
        updateMaps(mapjson.doors[doorTest - 1].toMapfile, maps, mapjson);
        return map = maps[0];
      }
    }
  }
});
game.addEventListener('touchstart', function(e) {
  return pad.check(e.x, e.y, game);
});
game.addEventListener('touchmove', function(e) {
  return pad.check(e.x, e.y, game);
});
game.addEventListener('touchend', function(e) {
  return pad.clear();
});
fireIntervalEvent = function(event) {
  return setInterval(function() {
    return game.fireEvent(event);
  }, 1000 / game.fps);
};
win.add(game);
view1 = Ti.UI.createView({
  backgroundColor: 'brown',
  width: game.width,
  height: 50,
  bottom: 0,
  borderColor: 'white',
  borderWidth: 2.0,
  opacity: 0.8
});
label1 = Ti.UI.createLabel({
  color: 'black',
  text: 'hide label',
  font: {
    fontSize: 15,
    fontFamily: 'Helvetica Neue'
  },
  textAlign: 'center',
  width: game.width - 20,
  height: 'auto',
  left: 10,
  bottom: 0,
  opacity: 0.8
});
label1.addEventListener('touchstart', function(e) {
  Ti.API.info("lavel1 touchstart");
  game.zIndex = 2;
  view1.zIndex = 1;
  return game.pushScene(scene);
});
label1.addEventListener('touchend', function(e) {
  Ti.API.info("lavel1 touchend");
  game.zIndex = 1;
  return view1.zIndex = 2;
});
view1.addEventListener('touchstart', function(e) {
  return Ti.API.info("view1 touchstart");
});
view1.add(label1);
win.add(view1);
win.open({
  fullscreen: true,
  navBarHidden: true
});
updatePad = function() {
  var i, nextPlayer, vx, vy, _i, _len;
  player.frame = (player.direction * 3) + 1;
  if (player.isMoving === true) {
    player.x += player.vx;
    player.y += player.vy;
    map.x -= map.vx;
    map.y -= map.vy;
    for (_i = 0, _len = maps.length; _i < _len; _i++) {
      i = maps[_i];
      i.x = map.x;
      i.y = map.y;
    }
    player.animate(player.direction * 3, 2, 250, -1);
    if (((player.vx !== 0) && (Math.abs(player.old_x - player.x) % player.width === 0)) || ((player.vy !== 0) && (Math.abs(player.old_y - player.y) % player.height === 0)) || ((map.vx !== 0) && (Math.abs(map.old_x - map.x) % player.width === 0)) || ((map.vy !== 0) && (Math.abs(map.old_y - map.y) % player.height === 0))) {
      player.isMoving = false;
      return player.walk = 1;
    }
  } else {
    player.vx = 0;
    player.vy = 0;
    map.vx = 0;
    map.vy = 0;
    vx = 0;
    vy = 0;
    player.old_x = player.x;
    player.old_y = player.y;
    map.old_x = map.x;
    map.old_y = map.y;
    nextPlayerX = 0;
    nextPlayerY = 0;
    nextMapX = 0;
    nextMapY = 0;
    if (pad.input.right) {
      player.direction = 2;
      vx = 4;
    }
    if (pad.input.left) {
      player.direction = 1;
      vx = -4;
    }
    if (pad.input.down) {
      player.direction = 0;
      vy = 4;
    }
    if (pad.input.up) {
      player.direction = 3;
      vy = -4;
    }
    if (vx === 0) {
      nextPlayerX = player.old_x;
      nextMapX = map.old_x;
    } else {
      nextPlayerX = player.old_x + player.width * (vx / (Math.abs(vx)));
      nextMapX = map.old_x - player.width * (vx / (Math.abs(vx)));
      nextPlayer = map.hitTest(nextPlayerX, player.old_y);
      if (nextPlayer === 0 || nextPlayer === false) {
        if ((0 <= nextPlayerX && nextPlayerX <= (game.screen.width - player.width))) {
          player.vx = vx;
          player.isMoving = true;
        } else if (0 >= nextMapX && nextMapX >= -map.width + game.screen.width) {
          map.vx = vx;
          player.isMoving = true;
        }
      }
    }
    if (vy === 0) {
      nextPlayerY = player.old_y;
      return nextMapY = map.old_y;
    } else {
      nextPlayerY = player.old_y + player.height * (vy / (Math.abs(vy)));
      nextMapY = map.old_y - player.height * (vy / (Math.abs(vy)));
      nextPlayer = map.hitTest(player.old_x, nextPlayerY);
      if (nextPlayer === 0 || nextPlayer === false) {
        if ((0 <= nextPlayerY && nextPlayerY <= (game.screen.height - player.height))) {
          player.vy = vy;
          return player.isMoving = true;
        } else if (0 >= nextMapY && nextMapY >= -map.height + game.screen.height) {
          map.vy = vy;
          return player.isMoving = true;
        }
      }
    }
  }
};