exports.MapTile = function() {
  var quicktigame2d, self;
  quicktigame2d = require('com.googlecode.quicktigame2d');
  self = quicktigame2d.createSpriteSheet({
    width: 16,
    height: 16,
    image: 'images/map1.png'
  });
  self.frame = 0;
  self.redraw = function(scene) {
    return scene.add(self);
  };
  return self;
};