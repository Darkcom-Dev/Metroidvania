extends Node2D

@export var range_min : int
@export var range_max : int
@export var spawn_points : int
@export var from_left : bool
var spawn_points_list : Array = []

@export var scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var _range : int = range_max - range_min
	var range_step : int = (_range / spawn_points)
	
	for i in range(0, spawn_points):
		spawn_points_list.append(int(range_min + i * range_step))
		
	print('spawn points list: ' + str(spawn_points_list))
	
	$spr_spawner.visible = false
	randomize()

func spawn():
	var scene_instance = scene.instantiate()
	
	add_child(scene_instance)
	var index = randi_range(0, spawn_points - 1)
	print('index: ' + str(index) + ' spawn_point: ' + str(spawn_points_list[index]))
	scene_instance.global_position.y = global_position.y + spawn_points_list[index]
	scene_instance.direction = -1 if from_left else 1
	


func _on_spawn_timer_timeout():
	spawn()
