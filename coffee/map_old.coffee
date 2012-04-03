exports.Map = ->
  #quicktigame2d = require 'com.googlecode.quicktigame2d'
  MapTile = require('map_tile').MapTile
  self = 
    data:[[]]
    collisionData:[[]]
    width:0
    height:0
    tileWidth:0
    tileHeight:0
    redraw:(_scale, _scene)->
      if _scale is false
        _scale = 1
      if _scene is false
        return
      for i in self.data
        for j in self.data[_i]
          tile_i_j = new MapTile()
          if self.tileWidth?
            self.tileWidth = tile_i_j.width
          if self.tileHeight?
            self.tileHeight = tile_i_j.height
          tile_i_j.scale _scale, _scale
          tile_i_j.x = tile_i_j.width*_j*tile_i_j.scaleX
          tile_i_j.y = tile_i_j.height*_i*tile_i_j.scaleY
          tile_i_j.frame = self.data[_i][_j]
          _scene.add tile_i_j
        self.width = self.data[0].length * self.tileWidth * _scale
        self.height = self.data.length * self.tileHeight * _scale
      Ti.API.info "map self.tileWidth="+self.tileWidth+", self.tileHeight="+self.tileHeight
      Ti.API.info "map self.width="+self.width+", self.height="+self.height
      Ti.API.info "map _scale="+_scale
    hitTest:(x, y)->
      Ti.API.info "hitTest x="+x+", y="+y
      Ti.API.info "hitTest self.width="+self.width+", self.height="+self.height
      Ti.API.info "hitTest self.scaleX="+self.scaleX+", self.scaleY="+self.scaleY
      if (x<0 or self.width<=x or y<0 or self.height<=y)
        return false
      #width = self.width*self.scaleX
      #height = self.height*self.scaleY
      width = self.width
      height = self.height
      tileWidth = self.tileWidth || width
      tileHeight = self.tileHeight || height
      x = if (x / tileWidth is 0) then 0 else (x / tileWidth - 1)
      y = if (y / tileHeight is 0) then 0 else (y / tileHeight - 1)
      #x = (x / tileWidth - 1) | 0
      #y = (y / tileHeight - 1) | 0
      Ti.API.info "hitTest 2 x="+x+", y="+y
      if self.collisionData isnt null
        Ti.API.info "hitTest self.collisionData[y][x]="+self.collisionData[y][x]
        return self.collisionData[y][x]
      else
        return false

  #self

