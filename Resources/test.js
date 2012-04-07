var test;
test = (function() {
  return Ti.API.info("test");
})(this);
(function() {
  return Ti.API.info("test");
})();