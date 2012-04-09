exports.fieldScene = (_game)->
  quicktigame2d = require 'com.googlecode.quicktigame2d'
  self = quicktigame2d.createScene()
  self.init = ->
  map = ""
  self.addEventListener 'activated',(e)->
    Ti.API.info "fieldScene activated"
    _game.addEventListener 'touchstart',(e)->
      Ti.API.info "fieldScene touchstart"
      Ti.API.info "e.x="+e.x+",e.y="+e.y
      pad.check e.x, e.y, _game
    _game.addEventListener 'touchmove',(e)->
      pad.check e.x, e.y, _game
    _game.addEventListener 'touchend',(e)->
      pad.clear()

  self.enterframe = ->
    _game.frame++
    self.updatePad()
    if player.isMoving is false
      doorTest = map.isDoor player.x, player.y
      if doorTest
        if mapjson.doors[doorTest - 1].toMapfile?
          clearMaps maps
          maps = []
          updateMaps mapjson.doors[doorTest - 1].toMapfile, maps, mapjson
          map = maps[0]

  #self.addEventListener 'enterframe',self.enterframe()
    
  self.addEventListener 'deactivated',(e)->
    Ti.API.info "fieldScene deactivated"
    _game.removeEventListener 'touchstart',(e)->
      pad.check e.x, e.y, _game
    _game.removeEventListener 'touchmove',(e)->
      pad.check e.x, e.y, _game
    _game.removeEventListener 'touchend',(e)->
      pad.clear()

  maps = []
  mapjson = ""
  Map = require('map').Map

  clearMaps = (_maps)->
    for i in _maps
      self.remove i
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
        self.add _maps[_i]
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
  pad.y = 360

  player.z = 10
  pad.z = 20
  self.add player
  self.add pad

  WINDOW_SCALE_FACTOR_X = 1
  WINDOW_SCALE_FACTOR_Y = 1
  nextPlayerX = 0
  nextPlayerY = 0
  nextMapX    = 0
  nextMapY    = 0
  player.isMoving = false

  self.updatePad = ->
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
          if (0 <= nextPlayerX <= (_game.screen.width - player.width))
            player.vx = vx
            player.isMoving = true
          else if 0 >= nextMapX and nextMapX >= -map.width + _game.screen.width
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
          if (0 <= nextPlayerY <= (_game.screen.height - player.height))
            player.vy = vy
            player.isMoving = true
          else if 0 >= nextMapY and nextMapY >= -map.height + _game.screen.height
              map.vy = vy
              player.isMoving = true

  self
