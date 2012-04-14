var testFunc;
exports.testScene = function(_game) {
  var quicktigame2d, testscene;
  quicktigame2d = require('com.googlecode.quicktigame2d');
  testscene = quicktigame2d.createScene();
  testscene.init = function() {};
  testscene.addEventListener('activated', function(e) {
    Ti.API.info("testScene activated");
    testscene.color(1, 0, 0);
    testscene.logo = quicktigame2d.createSprite({
      image: 'graphics/unused/a.png'
    });
    testscene.logo.x = (_game.width * 0.5) - (testscene.logo.width * 0.5);
    testscene.logo.y = (_game.height * 0.5) - (testscene.logo.height * 0.5);
    testscene.add(testscene.logo);
    return testscene.onLogoTransform();
  });
  testscene.addEventListener('enterframe', function(e) {
    return testFunc();
  });
  testscene.onLogoTransform = function() {
    testscene.logoTransform = quicktigame2d.createTransform();
    testscene.logoTransform.duration = 3000;
    testscene.logoTransform.alpha = 1;
    testscene.logoTransform.easing = quicktigame2d.ANIMATION_CURVE_CUBIC_IN;
    return testscene.logo.transform(testscene.logoTransform);
  };
  testscene.onSceneTransform = function() {
    testscene.sceneTransform = quicktigame2d.createTransform();
    testscene.sceneTransform.duration = 3000;
    testscene.sceneTransform.color(0, 0, 1);
    return testscene.transform(testscene.sceneTransform);
  };
  return testscene;
};
testFunc = function() {
  return Ti.API.info("testFunc called");
};