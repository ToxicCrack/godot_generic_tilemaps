extends Node2D

var maptiles = {}
#size of each tilemap in pixels
var tilemapSize = Vector2(6400, 6400)
onready var player = get_node("/root/Main").player
#we don't need to check every frame. So we have an interval time
var mapCheckInterval = 1.0
var mapCheckIntervalEl = 0

func _ready():
  set_physics_process(true)
  
  for tile in $tilemaps.get_children():
    var tmp = tile.name.right(tile.name.length() - 3).split("x")
    maptiles[tmp[0]+'x'+tmp[1]] = {'path': tile.get_path(), 'x': tmp[0], 'y': tmp[1]}
  
  
func getTilemap(x, y):
  var key = str(x)+"x"+str(y)
  if(!maptiles.has(key)):
    return null
  return maptiles[key]

func getGrid(pos = Vector2(), floored=true):
  var x = (pos.x / tilemapSize.x)
  var y = (pos.y / tilemapSize.y)
  if(floored):
    x = floor(x)
    y = floor(y)
  return Vector2(x, y)

func _physics_process(delta):
  mapCheckIntervalEl += delta
  if(mapCheckIntervalEl >= mapCheckInterval):
    mapCheckIntervalEl = 0
    self.checkMapTiles()
  
func checkMapTiles():
  var currentGrid = self.getGrid(self.player.position)
  var gridPos = self.getGrid(self.player.position, false) - currentGrid
  
  var visibleGrids = {}
  visibleGrids[str(currentGrid.x)+"x"+str(currentGrid.y)] = true
  #distance (percentage) from the player to the tilemap border
  var threshold = Vector2(0.2, 0.8)
  
  if(gridPos.x < threshold.x):
    #left
    visibleGrids[str(currentGrid.x-1)+"x"+str(currentGrid.y)] = true
  if(gridPos.x > threshold.y):
    #right
    visibleGrids[str(currentGrid.x+1)+"x"+str(currentGrid.y)] = true
  if(gridPos.y < threshold.x):
    #top
    visibleGrids[str(currentGrid.x)+"x"+str(currentGrid.y-1)] = true
  if(gridPos.y > threshold.y):
    #bottom
    visibleGrids[str(currentGrid.x)+"x"+str(currentGrid.y+1)] = true
    
  if(gridPos.y > threshold.y && gridPos.x > threshold.y):
    #bottom right
    visibleGrids[str(currentGrid.x+1)+"x"+str(currentGrid.y+1)] = true
  if(gridPos.y > threshold.y && gridPos.x < threshold.x):
    #bottom left
    visibleGrids[str(currentGrid.x+1)+"x"+str(currentGrid.y+1)] = true
  if(gridPos.y < threshold.x && gridPos.x > threshold.y):
    #top right
    visibleGrids[str(currentGrid.x+1)+"x"+str(currentGrid.y-1)] = true
  if(gridPos.y < threshold.x && gridPos.x < threshold.x):
    #top left
    visibleGrids[str(currentGrid.x-1)+"x"+str(currentGrid.y-1)] = true
  
  print(str(visibleGrids.size())+" Grids visible")
  
  for key in maptiles:
    if(visibleGrids.has(key)):
      get_node(maptiles[key].path).visible = true
    else:
      get_node(maptiles[key].path).visible = false
