exports.MapTile = ->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  self = quicktigame2d.createSpriteSheet
    width:16
    height:16
    #image:'images/map0.png'
    image:'images/map1.png'
  #self.scale 4,4 
  self.frame = 0

  self.redraw = (scene)->
    scene.add self

  self
