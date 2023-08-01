extends Node2D

@export var bgm_stream : AudioStream

@export var limit_left : int
@export var limit_top : int
@export var limit_right : int
@export var limit_bottom : int

@export var arrivals : Array
@export var default_position : Vector2

func set_player_arrival(node_paths_array):
	
	var is_founded : bool = false
	
	for node_path in node_paths_array:
		
		if not node_path.is_empty():
			print('Last_SCENE: ', GAME_MANAGER.location.last_scene, ' NodePATH: ', node_path.get_name(0))
			if GAME_MANAGER.location.last_scene == node_path.get_name(0):
				is_founded = true
				print('Get_name and last_scene: ' + node_path.get_name(0))	
				var node = get_node(node_path)
				# Definir el tipo Change room
				if GAME_MANAGER.is_vertical:
					PLAYER.global_position.y = node.global_position.y
				else:
					PLAYER.global_position.x = node.global_position.x
				break
			
		else:			
			print('Asigne bien los Markers y renombrelos con el nombre de escenas')
	
	return is_founded

func set_BGM():
	var stream : AudioStream = BGM.stream
	if stream != null and bgm_stream != null:
		if stream.resource_path != bgm_stream.resource_path:
			BGM.stop()
			BGM.stream = bgm_stream
			BGM.play()
	else:
		print('no existe stream')

func set_camera_limits():
	CAMERA.limit_left = limit_left
	CAMERA.limit_top = limit_top
	CAMERA.limit_right = limit_right
	CAMERA.limit_bottom = limit_bottom

func _ready():
	set_BGM()		
	set_camera_limits()
	
	print('LOADED_FROM_DISK: ', GAME_MANAGER.is_loaded_from_disk, ' PLAYER_ARRIVALS: ', set_player_arrival(arrivals))
	
	if not GAME_MANAGER.is_loaded_from_disk and not set_player_arrival(arrivals):
		PLAYER.global_position = default_position
		print('Asegurese de nombrar bien los Markers - ignore si es nueva campaña: ', default_position)
	
	print('GAMEMANAGER last scene: ' + GAME_MANAGER.location.last_scene)


func _on_right_body_entered(body):
	print('body_name' + body.name + 'is avaliable')
	get_tree().change_scene_to_file("res://Level/level_2.tscn")

func _on_left_room_body_entered(body):
	print('Left room body entered: ' + body.name)
	if body.is_in_group('player'):
		print('PLAYER ha entrado en area')
		

func _on_right_room_body_entered(body):
	print('Right room body entered: ' + body.name)
	if body.is_in_group('player'):
		print('PLAYER ha entrado en area')
		get_tree().change_scene_to_file("res://Level/level_2.tscn")



