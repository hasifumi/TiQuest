(->
  #Ti.API.info "osname="+Ti.Platform.osname
  #Ti.API.info "version="+Ti.Platform.version
  #Ti.API.info "width="+Ti.Platform.displayCaps.platformWidth
  #Ti.API.info "height="+Ti.Platform.displayCaps.platformHeight

  SCREEN_WIDTH = 320
  SCREEN_HEIGHT = 480
  GAME_FPS = 30
  win = Ti.UI.createWindow
    backaroudColor:'red'

  quicktigame2d = require 'com.googlecode.quicktigame2d'

  game = quicktigame2d.createGameView()
  game.fps = GAME_FPS
  game.color 1, 1, 1
  game.debug = true
  game.frame = 0

  #TestScene = require('testScene').testScene
  #testScene = new TestScene(game)

  FieldScene = require('fieldScene').fieldScene
  fieldScene = new FieldScene(game)

  game.addEventListener 'onload',(e)->
    screenScale = game.width / 320
    game.screen = 
      width:game.width / screenScale
      height:game.height / screenScale
    WINDOW_SCALE_FACTOR_X = game.screen.width / game.width
    WINDOW_SCALE_FACTOR_Y = game.screen.height / game.height
    #pad.y = game.screen.height - pad.height
    
    game.pushScene fieldScene

    game.start()

  fireIntervalEvent = (event)->
    setInterval ->
      game.fireEvent event
    ,( 1000 / game.fps )

  win.add game

  #view1 = Ti.UI.createView
  #  backgroundColor:'brown'
  #  #width:game.screen.width
  #  width:game.width
  #  height:50
  #  bottom:0
  #  borderColor:'white'
  #  borderWidth:2.0
  #  opacity:0.8

  #label1 = Ti.UI.createLabel
  #  color:'black'
  #  #backgroundColor:'pink'
  #  text:'hide label'
  #  font:
  #    fontSize:15
  #    fontFamily:'Helvetica Neue'
  #  textAlign:'center'
  #  #width:game.screen.width - 20
  #  width:game.width - 20
  #  height:'auto'
  #  left:10
  #  bottom:0
  #  #borderColor:'white'
  #  #borderWidth:2.0
  #  #borderRadius:5.0
  #  opacity:0.8

  #label1.addEventListener 'touchstart',(e)->
  #  Ti.API.info "lavel1 touchstart"
  #  #label1.hide()
  #  game.zIndex = 2
  #  view1.zIndex = 1
  #  game.pushScene scene

  #label1.addEventListener 'touchend',(e)->
  #  Ti.API.info "lavel1 touchend"
  #  game.zIndex = 1
  #  view1.zIndex = 2
  #  #game.pushScene scene

  #view1.addEventListener 'touchstart',(e)->
  #  Ti.API.info "view1 touchstart"
  #  #label1.show()

  #view1.add label1
  #win.add view1

  win.open
    fullscreen:true
    navBarHidden:true

)() 
