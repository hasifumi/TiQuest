exports.testScene = (_game)->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  testscene = quicktigame2d.createScene()
  testscene.init = ->
  testscene.addEventListener 'activated',(e)->
    Ti.API.info "testScene activated"
    testscene.color 1, 0, 0 
    #testscene.onSceneTransform()
    testscene.logo = quicktigame2d.createSprite
      image:'graphics/unused/a.png'
    testscene.logo.x = (_game.width * 0.5) - (testscene.logo.width * 0.5)
    testscene.logo.y = (_game.height * 0.5) - (testscene.logo.height * 0.5)
    testscene.add testscene.logo
    testscene.onLogoTransform()
  testscene.addEventListener 'enterframe',(e)->
    #Ti.API.info "testScene enterframed"
    testFunc()

  testscene.onLogoTransform = ->
    testscene.logoTransform = quicktigame2d.createTransform()
    testscene.logoTransform.duration = 3000
    testscene.logoTransform.alpha = 1
    testscene.logoTransform.easing = quicktigame2d.ANIMATION_CURVE_CUBIC_IN
    testscene.logo.transform testscene.logoTransform

  testscene.onSceneTransform = ->
    testscene.sceneTransform = quicktigame2d.createTransform()
    testscene.sceneTransform.duration = 3000
    testscene.sceneTransform.color 0, 0, 1  # blue
    testscene.transform testscene.sceneTransform

  testscene

testFunc = ->
  Ti.API.info "testFunc called"
