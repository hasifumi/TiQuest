exports.Player = ->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  self = quicktigame2d.createSpriteSheet
    width:32
    height:32
    #image:'images/chara0.png'
    image:'images/pipo-charachip001.png'
  self.frame = 0
  self.direction = 0
  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0
  self.old_x = 0
  self.old_y = 0
  self.walk = 0
  self.isMoving = false
  self.destroy = false

  self

#  self.enterframe = (game, pad, map)->
#    if game is false or pad is false or map is false
#      return
#    #self.frame = ( self.direction * 9 ) + self.walk
#    self.frame = ( self.direction * 3 ) + self.walk
#    if self.isMoving 
#      self.x += self.vx
#      self.y += self.vy
#      if (game.frame % 3) is 0
#        self.walk++
#        self.walk %= 3
#      if ((self.vx isnt 0) and (Math.abs(self.old_x - self.x) % self.width is 0)) or ((self.vy isnt 0) and (Math.abs(self.old_y - self.y) % self.height is 0))
#        self.isMoving = false
#        self.walk = 1
#    else
#      self.vx = 0
#      self.vy = 0
#      self.old_x = self.x
#      self.old_y = self.y
#      if pad.input.right
#        self.direction = 2
#        self.vx = 4
#      if pad.input.left
#        self.direction = 1
#        self.vx = -4
#      if pad.input.down
#        self.direction = 0
#        self.vy = 4
#      if pad.input.up 
#        self.direction = 3
#        self.vy = -4
#      if self.vx or self.vy
#        if self.vx is 0
#          x = self.x 
#        else
#          x = self.x + self.width*(self.vx / (Math.abs self.vx))
#        if self.vy is 0
#          y = self.y
#        else
#          y = self.y + self.height*(self.vy / (Math.abs self.vy)) 
#        #Ti.API.info "player.enterframe x="+x+", y="+y
#        #Ti.API.info "player.enterframe game.screen.width="+game.screen.width
#        #Ti.API.info "player.enterframe game.screen.height="+game.screen.height
#        #Ti.API.info "player.enterframe map.hitTest(x,y)="+map.hitTest(x, y)
#        #if ( 0 <= x <= (game.screen.width - self.width) ) and ( 0 <= y <= (game.screen.height - self.height - 8*self.scaleX) and (map.hitTest(x, y) is 0))
#        if ( 0 <= x <= (game.screen.width - self.width) ) and ( 0 <= y <= (game.screen.height - self.height - 8*self.scaleX) )
#        #if 0 < x < (game.screen.width - self.width)
#          self.isMoving = true
#    return
