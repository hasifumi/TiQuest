exports.fieldScene = function(_game) {
  var Map, Pad, Player, WINDOW_SCALE_FACTOR_X, WINDOW_SCALE_FACTOR_Y, clearMaps, map, mapjson, maps, nextMapX, nextMapY, nextPlayerX, nextPlayerY, pad, player, quicktigame2d, self, updateMaps;
  quicktigame2d = require('com.googlecode.quicktigame2d');
  self = quicktigame2d.createScene();
  self.init = function() {};
  map = "";
  maps = [];
  mapjson = "";
  Map = require('map').Map;
  clearMaps = function(_maps) {
    var i, _i, _len;
    for (_i = 0, _len = _maps.length; _i < _len; _i++) {
      i = _maps[_i];
      self.remove(i);
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
      _results.push(mapjson.layers[_i].type === 'tilelayer' ? (_map = new Map(_mapfile, _i), _maps.push(_map), _maps[_i].z = _i, self.add(_maps[_i]), _i === 0 ? (_maps[_i].loadCollisionData(), _maps[_i].loadDoorData()) : void 0) : void 0);
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
  pad.y = 360;
  player.z = 10;
  pad.z = 20;
  self.add(player);
  self.add(pad);
  WINDOW_SCALE_FACTOR_X = 1;
  WINDOW_SCALE_FACTOR_Y = 1;
  nextPlayerX = 0;
  nextPlayerY = 0;
  nextMapX = 0;
  nextMapY = 0;
  player.isMoving = false;
  self.updatePad = function() {
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
        Ti.API.info("player.x=" + player.x + ",y=" + player.y);
        Ti.API.info("map.x=" + map.x + ",y=" + map.y);
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
          if ((0 <= nextPlayerX && nextPlayerX <= (_game.screen.width - player.width))) {
            player.vx = vx;
            player.isMoving = true;
          } else if (0 >= nextMapX && nextMapX >= -map.width + _game.screen.width) {
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
          if ((0 <= nextPlayerY && nextPlayerY <= (_game.screen.height - player.height))) {
            player.vy = vy;
            return player.isMoving = true;
          } else if (0 >= nextMapY && nextMapY >= -map.height + _game.screen.height) {
            map.vy = vy;
            return player.isMoving = true;
          }
        }
      }
    }
  };
  self.enterframe = function() {
    var doorTest;
    _game.frame++;
    self.updatePad();
    if (player.isMoving === false) {
      doorTest = map.isDoor(player.x - map.x, player.y - map.y);
      if (doorTest) {
        if (mapjson.doors[doorTest - 1].toMapfile != null) {
          clearMaps(maps);
          maps = [];
          updateMaps(mapjson.doors[doorTest - 1].toMapfile, maps, mapjson);
          return map = maps[0];
        }
      }
    }
  };
  self.addEventListener('activated', function(e) {
    Ti.API.info("fieldScene activated");
    _game.addEventListener('touchstart', function(e) {
      return pad.check(e.x, e.y, _game);
    });
    _game.addEventListener('touchmove', function(e) {
      return pad.check(e.x, e.y, _game);
    });
    _game.addEventListener('touchend', function(e) {
      return pad.clear();
    });
    return _game.addEventListener('enterframe', function(e) {
      return self.enterframe();
    });
  });
  self.addEventListener('deactivated', function(e) {
    Ti.API.info("fieldScene deactivated");
    _game.removeEventListener('touchstart', function(e) {
      return pad.check(e.x, e.y, _game);
    });
    _game.removeEventListener('touchmove', function(e) {
      return pad.check(e.x, e.y, _game);
    });
    return _game.removeEventListener('touchend', function(e) {
      return pad.clear();
    });
  });
  return self;
};