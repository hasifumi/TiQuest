exports.Map = function(_mapfile, _idx) {
  var mapfile, mapinfo, mapjson, quicktigame2d, self;
  if (_mapfile === null) {
    return;
  }
  if (_idx === null) {
    _idx = 0;
  }
  quicktigame2d = require('com.googlecode.quicktigame2d');
  mapfile = Ti.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory, _mapfile);
  mapjson = JSON.parse(mapfile.read().toString());
  mapinfo = {
    image: mapjson.tilesets[0].image,
    tileWidth: mapjson.tilesets[0].tilewidth,
    tileHeight: mapjson.tilesets[0].tileheight,
    border: mapjson.tilesets[0].spacing,
    margin: mapjson.tilesets[0].margin
  };
  self = quicktigame2d.createMapSprite(mapinfo);
  if (mapjson.layers[_idx].data === null || mapjson.layers[_idx].data === void 0) {
    Ti.API.info("Map layers[_idx].data is false or undefined");
    return;
  }
  self.width = self.tileWidth * mapjson.layers[_idx].width;
  self.height = self.tileHeight * mapjson.layers[_idx].height;
  self.firstgid = mapjson.tilesets[0].firstgid;
  self.tiles = mapjson.layers[_idx].data;
  self.collisionData = [];
  self.doorData = [];
  self.loadCollisionData = function() {
    var i, _i, _len, _ref, _results;
    _ref = mapjson.layers;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(mapjson.layers[_i].name === "collision" ? self.collisionData = mapjson.layers[_i].data : void 0);
    }
    return _results;
  };
  self.loadDoorData = function() {
    var i, _i, _len, _ref, _results;
    _ref = mapjson.layers;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(mapjson.layers[_i].name === "door" ? self.doorData = mapjson.layers[_i].data : void 0);
    }
    return _results;
  };
  self.hitTest = function(x, y) {
    var XY, leng;
    if (x < 0 || self.width < x || y < 0 || self.height < y) {
      return false;
    }
    x = x / self.tileWidth === 0 ? 0 : x / self.tileWidth;
    y = y / self.tileHeight === 0 ? 0 : y / self.tileHeight;
    leng = self.width / self.tileWidth;
    XY = y * leng + x;
    if (self.collisionData[XY] != null) {
      return self.collisionData[XY];
    } else {
      return false;
    }
  };
  self.isDoor = function(x, y) {
    var XY, leng;
    if (x < 0 || self.width < x || y < 0 || self.height < y) {
      return false;
    }
    x = x / self.tileWidth === 0 ? 0 : x / self.tileWidth;
    y = y / self.tileHeight === 0 ? 0 : y / self.tileHeight;
    leng = self.width / self.tileWidth;
    XY = y * leng + x;
    if (self.doorData[XY] != null) {
      return self.doorData[XY];
    } else {
      return false;
    }
  };
  return self;
};