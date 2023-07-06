extends Node2D

@export var from_left : Sprite2D
@export var left_scene: String
@export var from_right: Sprite2D
@export var right_scene:String

func _ready():
	
	if left_scene == GAME_MANAGER.location.last_scene:
		PLAYER.position.x = from_left.position.x
		PLAYER.position.y = GAME_MANAGER.location.player_pos.y
		from_left.visible = false
	elif GAME_MANAGER.last_scene == right_scene:
		PLAYER.position.x = from_right.position.x
		PLAYER.position.y = GAME_MANAGER.location.player_pos.y
		from_right.visible = false
	else:
		PLAYER.position.x = 40
		PLAYER.position.y = 192
	#CAMERA.Tilemap = TileMap
	CAMERA.limit_left = 0
	CAMERA.limit_top = 0
	CAMERA.limit_right = 768
	CAMERA.limit_bottom = 432


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
