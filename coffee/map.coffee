exports.Map = (_mapfile, _idx)->
  if _mapfile is null
    return
  if _idx is null
    _idx = 0

  quicktigame2d = require 'com.googlecode.quicktigame2d'

  mapfile = Ti.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory, _mapfile)
  mapjson = JSON.parse mapfile.read().toString()
  mapinfo =
    image:mapjson.tilesets[0].image
    tileWidth:mapjson.tilesets[0].tilewidth
    tileHeight:mapjson.tilesets[0].tileheight
    border:mapjson.tilesets[0].spacing
    margin:mapjson.tilesets[0].margin

  self = quicktigame2d.createMapSprite mapinfo
  if mapjson.layers[_idx].data is null or mapjson.layers[_idx].data is undefined
    Ti.API.info "Map layers[_idx].data is false or undefined"
    return
  self.width = self.tileWidth * mapjson.layers[_idx].width
  self.height = self.tileHeight * mapjson.layers[_idx].height
  self.firstgid = mapjson.tilesets[0].firstgid
  self.tiles = mapjson.layers[_idx].data
  self.collisionData = []
  self.doorData = []
  
  #self = quicktigame2d.createMapSprite 
  #  image:'graphics/desert_tiles.png'
  #  tileWidth:32
  #  tileHeight:32
  #  border:1
  #  margin:1
  #self.width = self.tileWidth * 5
  #self.height = self.tileHeight * 5 
  #self.tiles = [29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29]
  ##self.collisionData = [
  ##  [ 0,  0,  0,  0,  1]
  ##  [ 0,  0,  0,  0,  1]
  ##  [ 0,  0,  0,  0,  1]
  ##  [ 0,  0,  0,  0,  1]
  ##  [ 1,  1,  1,  1,  1]
  ##]
  #self.collisionData = [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,1,1,1,1,1]

  self.loadCollisionData = ->
    for i in mapjson.layers
      if mapjson.layers[_i].name is "collision"
        self.collisionData = mapjson.layers[_i].data

  self.loadDoorData = ->
    for i in mapjson.layers
      if mapjson.layers[_i].name is "door"
        self.doorData = mapjson.layers[_i].data

  self.hitTest = (x, y)->
    if (x<0 or self.width<x or y<0 or self.height<y)
      return false
    x = if (x / self.tileWidth is 0) then 0 else (x / self.tileWidth)
    y = if (y / self.tileHeight is 0) then 0 else (y / self.tileHeight)
    leng = self.width / self.tileWidth
    XY = y*leng+x
    if self.collisionData[XY]?
      return self.collisionData[XY]
    else
      return false

  self.isDoor = (x, y)->
    if (x<0 or self.width<x or y<0 or self.height<y)
      return false
    x = if (x / self.tileWidth is 0) then 0 else (x / self.tileWidth)
    y = if (y / self.tileHeight is 0) then 0 else (y / self.tileHeight)
    leng = self.width / self.tileWidth
    XY = y*leng+x
    if self.doorData[XY]?
      return self.doorData[XY]
    else
      return false

  self


#mapfile = Ti.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory, 'graphics/desert.json')
#mapjson = JSON.parse mapfile.read().toString()
#mapinfo =
#  image:mapjson.tilesets[0].image
#  tileWidth:mapjson.tilesets[0].tilewidth
#  tileHeight:mapjson.tilesets[0].tileheight
#  border:mapjson.tilesets[0].spacing
#  margin:mapjson.tilesets[0].margin
#
#map = quicktigame2d.createMapSprite mapinfo
#map.width = map.tileWidth * mapjson.layers[0].width
#map.height = map.tileHeight * mapjson.layers[0].height
#map.firstgid = mapjson.tilesets[0].firstgid
#map.tiles = mapjson.layers[0].data


#MapTile = require('map_tile').MapTile
#  self = 
#    data:[[]]
#    collisionData:[[]]
#    width:0
#    height:0
#    tileWidth:0
#    tileHeight:0
#    redraw:(_scale, _scene)->
#      if _scale is false
#        _scale = 1
#      if _scene is false
#        return
#      for i in self.data
#        for j in self.data[_i]
#          tile_i_j = new MapTile()
#          if self.tileWidth?
#            self.tileWidth = tile_i_j.width
#          if self.tileHeight?
#            self.tileHeight = tile_i_j.height
#          tile_i_j.scale _scale, _scale
#          tile_i_j.x = tile_i_j.width*_j*tile_i_j.scaleX
#          tile_i_j.y = tile_i_j.height*_i*tile_i_j.scaleY
#          tile_i_j.frame = self.data[_i][_j]
#          _scene.add tile_i_j
#        self.width = self.data[0].length * self.tileWidth * _scale
#        self.height = self.data.length * self.tileHeight * _scale
#      Ti.API.info "map self.tileWidth="+self.tileWidth+", self.tileHeight="+self.tileHeight
#      Ti.API.info "map self.width="+self.width+", self.height="+self.height
#      Ti.API.info "map _scale="+_scale
#    hitTest:(x, y)->
#      Ti.API.info "hitTest x="+x+", y="+y
#      Ti.API.info "hitTest self.width="+self.width+", self.height="+self.height
#      Ti.API.info "hitTest self.scaleX="+self.scaleX+", self.scaleY="+self.scaleY
#      if (x<0 or self.width<=x or y<0 or self.height<=y)
#        return false
#      #width = self.width*self.scaleX
#      #height = self.height*self.scaleY
#      width = self.width
#      height = self.height
#      tileWidth = self.tileWidth || width
#      tileHeight = self.tileHeight || height
#      x = if (x / tileWidth is 0) then 0 else (x / tileWidth - 1)
#      y = if (y / tileHeight is 0) then 0 else (y / tileHeight - 1)
#      #x = (x / tileWidth - 1) | 0
#      #y = (y / tileHeight - 1) | 0
#      Ti.API.info "hitTest 2 x="+x+", y="+y
#      if self.collisionData isnt null
#        Ti.API.info "hitTest self.collisionData[y][x]="+self.collisionData[y][x]
#        return self.collisionData[y][x]
#      else
#        return false
#
#  #self

