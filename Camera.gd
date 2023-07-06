extends Camera2D

@onready var player = get_tree().get_nodes_in_group('player')[0]

var counter = 0
var power = 0

# ---------------- CameraShake
@onready var rng = RandomNumberGenerator.new()

func random(min_float : float, max_float : float) -> float:
	rng.randomize()
	return rng.randf_range(min_float, max_float)

func shake_camera(shake_power : float) -> void:
	offset = Vector2(random(-shake_power,shake_power),random(-shake_power,shake_power))

#func screen_shake(length : float, power : float, priority : float):	$anim_camera.play("Shake")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player.is_inside_tree():
		global_position = player.global_position #lerp(global_position,player.global_position, 0.1)
	
	if counter > 0:
		shake_camera(power)
		counter -= 1
	

	
	
	
	
