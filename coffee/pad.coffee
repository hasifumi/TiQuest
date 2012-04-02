exports.Pad = ->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  self = quicktigame2d.createSpriteSheet
    width:100
    height:100
    image:'images/pad.png'
  self.frame = 0
  self.x = 0
  self.y = 0
  self.input =
    up:false
    down:false
    left:false
    right:false

  self.clear = ()->
    self.input =
      up:false
      down:false
      left:false
      right:false
    return
    
  self.check = (x, y, game)->
    if x is false or y is false or game is false
      return
    if (self.x <= x <= self.width) and (self.y <= y <= game.screen.height)
      self.input =
        up:false
        down:false
        left:false
        right:false
      if ( y <= self.y + x ) and ( y <= game.screen.height - x )
        self.input =
          up:true
      if ( y >= self.y + x ) and ( y >= game.screen.height - x )
        self.input =
          down:true
      if ( y >= self.y + x ) and ( y <= game.screen.height - x )
        self.input =
          left:true
      if ( y <= self.y + x ) and ( y >= game.screen.height - x )
        self.input =
          right:true
    return

  self
