exports.Map = function() {
  var MapTile, self;
  MapTile = require('map_tile').MapTile;
  return self = {
    data: [[]],
    collisionData: [[]],
    width: 0,
    height: 0,
    tileWidth: 0,
    tileHeight: 0,
    redraw: function(_scale, _scene) {
      var i, j, tile_i_j, _i, _j, _len, _len2, _ref, _ref2;
      if (_scale === false) {
        _scale = 1;
      }
      if (_scene === false) {
        return;
      }
      _ref = self.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        _ref2 = self.data[_i];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          j = _ref2[_j];
          tile_i_j = new MapTile();
          if (self.tileWidth != null) {
            self.tileWidth = tile_i_j.width;
          }
          if (self.tileHeight != null) {
            self.tileHeight = tile_i_j.height;
          }
          tile_i_j.scale(_scale, _scale);
          tile_i_j.x = tile_i_j.width * _j * tile_i_j.scaleX;
          tile_i_j.y = tile_i_j.height * _i * tile_i_j.scaleY;
          tile_i_j.frame = self.data[_i][_j];
          _scene.add(tile_i_j);
        }
        self.width = self.data[0].length * self.tileWidth * _scale;
        self.height = self.data.length * self.tileHeight * _scale;
      }
      Ti.API.info("map self.tileWidth=" + self.tileWidth + ", self.tileHeight=" + self.tileHeight);
      Ti.API.info("map self.width=" + self.width + ", self.height=" + self.height);
      return Ti.API.info("map _scale=" + _scale);
    },
    hitTest: function(x, y) {
      var height, tileHeight, tileWidth, width;
      Ti.API.info("hitTest x=" + x + ", y=" + y);
      Ti.API.info("hitTest self.width=" + self.width + ", self.height=" + self.height);
      Ti.API.info("hitTest self.scaleX=" + self.scaleX + ", self.scaleY=" + self.scaleY);
      if (x < 0 || self.width <= x || y < 0 || self.height <= y) {
        return false;
      }
      width = self.width;
      height = self.height;
      tileWidth = self.tileWidth || width;
      tileHeight = self.tileHeight || height;
      x = x / tileWidth === 0 ? 0 : x / tileWidth - 1;
      y = y / tileHeight === 0 ? 0 : y / tileHeight - 1;
      Ti.API.info("hitTest 2 x=" + x + ", y=" + y);
      if (self.collisionData !== null) {
        Ti.API.info("hitTest self.collisionData[y][x]=" + self.collisionData[y][x]);
        return self.collisionData[y][x];
      } else {
        return false;
      }
    }
  };
};