extends Node2D

@export var top_left : Vector2
@export var bottom_right : Vector2
@export var scene : PackedScene


func _on_spawn_timer_timeout():
	var spawn_point : Vector2 = Vector2(randf_range(top_left.x, bottom_right.x), randf_range(top_left.y, bottom_right.y)) 
	if scene != null:
		var scene_instance = scene.instantiate()
		add_child(scene_instance)
		scene_instance.global_position = spawn_point
	
