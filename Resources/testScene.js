exports.testScene = function(_game) {
  var quicktigame2d, self;
  quicktigame2d = require('com.googlecode.quicktigame2d');
  self = quicktigame2d.createScene();
  self.init = function() {};
  self.addEventListener('activated', function(e) {
    Ti.API.info("testScene activated");
    self.color(1, 0, 0);
    self.logo = quicktigame2d.createSprite({
      image: 'graphics/unused/a.png'
    });
    self.logo.x = (_game.width * 0.5) - (self.logo.width * 0.5);
    self.logo.y = (_game.height * 0.5) - (self.logo.height * 0.5);
    self.add(self.logo);
    return self.onLogoTransform();
  });
  self.addEventListener('enterframe', function(e) {});
  self.onLogoTransform = function() {
    self.logoTransform = quicktigame2d.createTransform();
    self.logoTransform.duration = 3000;
    self.logoTransform.alpha = 1;
    self.logoTransform.easing = quicktigame2d.ANIMATION_CURVE_CUBIC_IN;
    return self.logo.transform(self.logoTransform);
  };
  self.onSceneTransform = function() {
    self.sceneTransform = quicktigame2d.createTransform();
    self.sceneTransform.duration = 3000;
    self.sceneTransform.color(0, 0, 1);
    return self.transform(self.sceneTransform);
  };
  return self;
};