extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var floorTileScene
var floorTiles = []
var litTileScene

var tmpTile
var tileMoveFlag = false

var i = 0
var a = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	floorTileScene = load("res://scenes/floorTile.tscn")

	# for i in range(2):
	# 	tmpTile = floorTileScene.instance()
	# 	add_child(tmpTile)
	# 	tmpTile.translate(Vector3(-.5+i,0,0))
	# 	floorTiles.append(tmpTile)

	# for i in range(9):
	# 	for a in range(9):
	# 		tmpTile = floorTileScene.instance()
	# 		add_child(tmpTile)
	# 		# tmpTile.translate(Vector3(((a)-4), -200+i, -i+5))
	# 		tmpTile.global_transform.origin = Vector3(((a)-4), -50+i+a, -i+5)
	# 		floorTiles.append(tmpTile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if len(floorTiles) < 100:
		print('less than 100')
		if i%10 == 0:
			print('a+')
			a += 1
		tmpTile = floorTileScene.instance()
		add_child(tmpTile)
		# tmpTile.translate(Vector3(((a)-4), -200+i, -i+5))
		tmpTile.global_transform.origin = Vector3(((a)-4), -50+i+a, -i+5)
		floorTiles.append(tmpTile)
	else:
		tileMoveFlag = true

	if tileMoveFlag == true:
		checkAndMoveTiles()

func checkAndMoveTiles():
	tileMoveFlag = false
	for tile in floorTiles:
		if tile.global_transform.origin.y < 0:
			# tile.translate(Vector3(0,1,0))
			tile.global_transform.origin.y += .1
			if (tile.global_transform.origin.y < 1 && tile.global_transform.origin.y > 0 ):
				tile.global_transform.origin.y = 0
			else:
				tileMoveFlag = true
		# else:
			#print(tile.global_transform.origin)
