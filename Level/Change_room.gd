extends Area2D

@export var scene : String
@export var is_vertical : bool = false

func _on_body_entered(body):
	
	if body.is_in_group('player'):
		
		# Disable platform check
		GAME_MANAGER.is_vertical = is_vertical
		GAME_MANAGER.location.player_pos = body.position
		GAME_MANAGER.is_loaded_from_disk = false
		
		# Obtener el nombre del nodo
		GAME_MANAGER.location.last_scene = get_tree().get_current_scene().name
		get_tree().change_scene_to_file(scene)
