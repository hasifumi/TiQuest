SCREEN_WIDTH = 320
SCREEN_HEIGHT = 480
GAME_FPS = 30
win = Ti.UI.createWindow
  backaroudColor:'red'
  #orientationMode:[Ti.UI.LANDSCAPE_RIGHT]
  #orientationMode:[# {{{
  #  Ti.UI.PORTRAIT,
  #  Ti.UI.UPSIDE_PORTRAIT,
  #  Ti.UI.LANDSCAPE_LEFT,
  #  Ti.UI.LANDSCAPE_RIGHT,
  #  Ti.UI.FACE_UP,
  #  Ti.UI.FACE_DOWN]# }}}

quicktigame2d = require 'com.googlecode.quicktigame2d'

game = quicktigame2d.createGameView()
game.fps = GAME_FPS
game.color 1, 1, 1
game.debug = true
game.frame = 0

#win.orientationMode = [Ti.UI.LANDSCAPE_RIGHT]
#game.orientation = Ti.UI.LANDSCAPE_RIGHT

scene = quicktigame2d.createScene()
scene.color 1, 1, 1

maps = []
mapjson = ""
Map = require('map').Map

clearMaps = (_maps)->
  for i in _maps
    scene.remove i
    i = null
  _maps = []

updateMaps = (_mapfile, _maps, _mapjson)->
  setTimeout ->
    Ti.API.debug "Sleep 3 sec."
  , 3000
  mapfile = Ti.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory, _mapfile)
  mapjson = JSON.parse mapfile.read().toString()
  _mapjson = mapjson
  for i in mapjson.layers
    if mapjson.layers[_i].type is 'tilelayer'
      _map =  new Map _mapfile, _i
      _maps.push _map
      _maps[_i].z = _i
      scene.add _maps[_i]
      if _i is 0
        _maps[_i].loadCollisionData()
        _maps[_i].loadDoorData()

updateMaps 'graphics/map/map001.json', maps, mapjson
map = maps[0]

Player = require('player').Player
player = new Player()

Pad = require('pad').Pad
pad = new Pad()
pad.color 1, 0, 0

player.z = 10
pad.z = 20
scene.add player
scene.add pad

WINDOW_SCALE_FACTOR_X = 1
WINDOW_SCALE_FACTOR_Y = 1
nextPlayerX = 0
nextPlayerY = 0
nextMapX    = 0
nextMapY    = 0
player.isMoving = false

game.pushScene scene

game.addEventListener 'onload',(e)->
  #Titanium.UI.orientation = Titanium.UI.LANDSCAPE_RIGHT
  #Ti.API.info "Ti.UI.isPortrate="+Ti.UI.isPortrate
  #Ti.API.info "Ti.UI.isLandscape="+Ti.UI.isLandscape
  screenScale = game.width / 320
  #screenScale = game.width / 480
  #screenScale = game.height / 640
  game.screen = 
    width:game.width / screenScale
    height:game.height / screenScale
  WINDOW_SCALE_FACTOR_X = game.screen.width / game.width
  WINDOW_SCALE_FACTOR_Y = game.screen.height / game.height
  #game.screen = 
  #  height:game.width / screenScale
  #  width:game.height / screenScale
  #WINDOW_SCALE_FACTOR_Y = game.screen.width / game.width
  #WINDOW_SCALE_FACTOR_X = game.screen.height / game.height
  Ti.API.info "game.width="+game.width
  Ti.API.info "game.height="+game.height
  Ti.API.info "screenScale="+screenScale
  Ti.API.info "game.screen.width="+game.screen.width
  Ti.API.info "game.screen.height="+game.screen.height
  pad.y = game.screen.height - pad.height
  game.start()
  Ti.API.info "player.x="+player.x+",y="+player.y
  Ti.API.info "pad.x="+pad.x+",y="+pad.y
  Ti.API.info "map.x="+map.x+",y="+map.y
  fireIntervalEvent 'enterframe1'

game.addEventListener 'enterframe1',(e)->
  game.frame++
  updatePad()
  if player.isMoving is false
    doorTest = map.isDoor player.x, player.y
    if doorTest
      if mapjson.doors[doorTest - 1].toMapfile?
        #Ti.API.info "mapjson.doors[doorTest - 1].toMapfile="+mapjson.doors[doorTest - 1].toMapfile
        clearMaps maps
        maps = []
        updateMaps mapjson.doors[doorTest - 1].toMapfile, maps, mapjson
        map = maps[0]

game.addEventListener 'touchstart',(e)->
  #Ti.API.info "e.x="+e.x+",y="+e.y
  #player.x = e.x
  #player.y = e.y
  pad.check e.x, e.y, game

game.addEventListener 'touchmove',(e)->
  pad.check e.x, e.y, game

game.addEventListener 'touchend',(e)->
  pad.clear()

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
#
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
#
#label1.addEventListener 'touchstart',(e)->
#  Ti.API.info "lavel1 touchstart"
#  #label1.hide()
#  game.zIndex = 2
#  view1.zIndex = 1
#
#label1.addEventListener 'touchend',(e)->
#  Ti.API.info "lavel1 touchend"
#  game.zIndex = 1
#  view1.zIndex = 2
#
#view1.addEventListener 'touchstart',(e)->
#  Ti.API.info "view1 touchstart"
#  #label1.show()
#
#view1.add label1
#win.add view1

win.open
  fullscreen:true
  navBarHidden:true

updatePad = ->
  player.frame = (player.direction * 3) + 1
  if player.isMoving is true
    player.x += player.vx
    player.y += player.vy
    map.x -= map.vx
    map.y -= map.vy
    for i in maps
      i.x = map.x
      i.y = map.y
    player.animate player.direction*3, 2, 250, -1
    if ((player.vx isnt 0) and (Math.abs(player.old_x - player.x) % player.width is 0)) or ((player.vy isnt 0) and (Math.abs(player.old_y - player.y) % player.height is 0)) or ((map.vx isnt 0) and (Math.abs(map.old_x - map.x) % player.width is 0)) or ((map.vy isnt 0) and (Math.abs(map.old_y - map.y ) % player.height is 0))
      player.isMoving = false
      player.walk = 1
  else
    player.vx = 0
    player.vy = 0
    map.vx = 0
    map.vy = 0
    vx = 0
    vy = 0
    player.old_x = player.x
    player.old_y = player.y
    map.old_x = map.x
    map.old_y = map.y
    nextPlayerX = 0
    nextPlayerY = 0
    nextMapX    = 0
    nextMapY    = 0
    if pad.input.right
      player.direction = 2
      vx = 4
    if pad.input.left
      player.direction = 1
      vx = -4
    if pad.input.down
      player.direction = 0
      vy = 4
    if pad.input.up
      player.direction = 3
      vy = -4
      
    if vx is 0
      nextPlayerX = player.old_x
      nextMapX    = map.old_x
    else
      nextPlayerX = player.old_x + player.width*(vx / (Math.abs vx))
      nextMapX    = map.old_x - player.width*(vx / (Math.abs vx))
      nextPlayer  = map.hitTest(nextPlayerX, player.old_y)
      if nextPlayer is 0 or nextPlayer is false
        if (0 <= nextPlayerX <= (game.screen.width - player.width))
          player.vx = vx
          player.isMoving = true
        else if 0 >= nextMapX and nextMapX >= -map.width + game.screen.width
            map.vx = vx
            player.isMoving = true
    if vy is 0
      nextPlayerY = player.old_y
      nextMapY    = map.old_y
    else
      nextPlayerY = player.old_y + player.height*(vy / (Math.abs vy))
      nextMapY    = map.old_y - player.height*(vy / (Math.abs vy))
      nextPlayer  = map.hitTest(player.old_x, nextPlayerY)
      if nextPlayer is 0 or nextPlayer is false
        if (0 <= nextPlayerY <= (game.screen.height - player.height))
          player.vy = vy
          player.isMoving = true
        else if 0 >= nextMapY and nextMapY >= -map.height + game.screen.height
            map.vy = vy
            player.isMoving = true

