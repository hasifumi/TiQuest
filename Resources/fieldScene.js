exports.fieldScene = function(_game) {
  var quicktigame2d, self;
  quicktigame2d = require('com.googlecode.quicktigame2d');
  self = quicktigame2d.createScene();
  self.init = function() {};
  self.addEventListener('activated', function(e) {
    return Ti.API.info("fieldScene activated");
  });
  self.addEventListener('enterframe', function(e) {});
  return self;
};