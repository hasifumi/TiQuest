exports.fieldScene = (_game)->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  self = quicktigame2d.createScene()
  self.init = ->
  self.addEventListener 'activated',(e)->
    Ti.API.info "fieldScene activated"
    self.color 1, 0, 0 
    #self.onSceneTransform()
    self.logo = quicktigame2d.createSprite
      image:'graphics/unused/a.png'
    self.logo.x = (_game.width * 0.5) - (self.logo.width * 0.5)
    self.logo.y = (_game.height * 0.5) - (self.logo.height * 0.5)
    self.add self.logo
    self.onLogoTransform()
  self.addEventListener 'enterframe',(e)->
    #Ti.API.info "fieldScene enterframed"

  self.onLogoTransform = ->
    self.logoTransform = quicktigame2d.createTransform()
    self.logoTransform.duration = 3000
    self.logoTransform.alpha = 1
    self.logoTransform.easing = quicktigame2d.ANIMATION_CURVE_CUBIC_IN
    self.logo.transform self.logoTransform

  self.onSceneTransform = ->
    self.sceneTransform = quicktigame2d.createTransform()
    self.sceneTransform.duration = 3000
    self.sceneTransform.color 0, 0, 1  # blue
    self.transform self.sceneTransform

  self
