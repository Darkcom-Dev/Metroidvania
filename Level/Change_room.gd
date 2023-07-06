extends Area2D

@export var scene : String
@export var is_vertical : bool = false
# Called when the node enters the scene tree for the first time.


func _on_body_entered(body):
	
	if body.is_in_group('player'):
		
		# Disable platform check
		body.disable_platform_check()
		GAME_MANAGER.is_vertical = is_vertical
		# Save player position
		GAME_MANAGER.location.player_pos = body.position
		
		GAME_MANAGER.is_loaded_from_disk = false
		
		var current_scene = get_tree().get_current_scene()
		# Convertir la escena en un nodo
		var current_node = current_scene.name

		# Obtener el nombre del nodo
		var current_node_name = current_node
		GAME_MANAGER.location.last_scene = current_node_name
		get_tree().change_scene_to_file(scene)
