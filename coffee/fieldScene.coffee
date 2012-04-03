exports.fieldScene = (_game)->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  self = quicktigame2d.createScene()
  self.init = ->
  self.addEventListener 'activated',(e)->
    Ti.API.info "fieldScene activated"
  self.addEventListener 'enterframe',(e)->
    #Ti.API.info "fieldScene enterframed"

  self
