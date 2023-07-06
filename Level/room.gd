extends Node2D

@export var limit_left : int
@export var limit_top : int
@export var limit_right : int
@export var limit_bottom : int

@export var from_left : Sprite2D
@export var left_scene: String
@export var from_right: Sprite2D
@export var right_scene:String

@export var bgm_stream : AudioStreamOggVorbis
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Ajustando la posicion del personaje
	if left_scene == GAME_MANAGER.last_scene:
		PLAYER.position.x = from_left.position.x
		PLAYER.position.y = GAME_MANAGER.player_pos_y
		from_left.visible = false
	elif GAME_MANAGER.last_scene == right_scene:
		PLAYER.position.x = from_right.position.x
		PLAYER.position.y = GAME_MANAGER.player_pos_y
		from_right.visible = false
	else:
		PLAYER.position.x = 210
		PLAYER.position.y = 257
	
	# Ajustando los limites de la camara
	CAMERA.limit_left = limit_left
	CAMERA.limit_top = limit_top
	CAMERA.limit_right = limit_right
	CAMERA.limit_bottom = limit_bottom
	
	# Ajustando el Audio BGM
	if BGM.stream != bgm_stream:
		BGM.stream = bgm_stream
		BGM.play()

	print('GAMEMANAGER last scene: ' + GAME_MANAGER.last_scene)



