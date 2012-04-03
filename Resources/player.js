exports.Player = function() {
  var quicktigame2d, self;
  quicktigame2d = require('com.googlecode.quicktigame2d');
  self = quicktigame2d.createSpriteSheet({
    width: 32,
    height: 32,
    image: 'images/pipo-charachip001.png'
  });
  self.frame = 0;
  self.direction = 0;
  self.x = 0;
  self.y = 0;
  self.vx = 0;
  self.vy = 0;
  self.old_x = 0;
  self.old_y = 0;
  self.walk = 0;
  self.isMoving = false;
  self.destroy = false;
  return self;
};