extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var floorTileScene
var floorTiles = []
var litTileScene

var tmpTile
var tileMoveFlag = true

# Called when the node enters the scene tree for the first time.
func _ready():
	floorTileScene = load("res://scenes/floorTile.tscn")

	for i in range(2):
		tmpTile = floorTileScene.instance()
		add_child(tmpTile)
		tmpTile.translate(Vector3(-.5+i,0,0))
		floorTiles.append(tmpTile)

	for i in range(100):
		if i == 0:
			i = 1
		for a in range(2):
			tmpTile = floorTileScene.instance()
			add_child(tmpTile)
			tmpTile.translate(Vector3(((a)-.5), -200+i, -i))
			floorTiles.append(tmpTile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if tileMoveFlag == true:
		checkAndMoveTiles()

func checkAndMoveTiles():
	tileMoveFlag = false
	for tile in floorTiles:
		if tile.global_transform.origin.y < 0:
			tile.translate(Vector3(0,1,0))
			tileMoveFlag = true
