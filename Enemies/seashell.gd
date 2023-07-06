extends Base_enemy

@export var is_right_direction : bool
@export var pearl_scene : PackedScene

var is_attacking : bool = false

func _ready():
	$spr_seashell.flip_h = is_right_direction
	$ray_attack.target_position.x = $ray_attack.target_position.x * -1 if is_right_direction else $ray_attack.target_position.x
	$ray_attack.position.x = 24 if is_right_direction else -24
	rotation_degrees = int(rotation_degrees)
	if rotation_degrees == 179 or rotation_degrees == 181:
		rotation_degrees = 180

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and rotation_degrees == 0:
		velocity.y += gravity * delta

	if $ray_attack.is_colliding() and not is_attacking and not is_dead:
		print('attacking')
		is_attacking = true
		attack()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.


	move_and_slide()

func attack():
	$anim_seashell.play("Fire")
	$attack_timer.start()
	

func hurt():
	$anim_seashell.play("Hit")
	$hurting_timer.start()

func dead_anim():
	$anim_seashell.play("Dead")
	$parteA.emitting = true
	$parteB.emitting = true
	$parteC.emitting = true
	$parteD.emitting = true
	$explosion_sfx.play()

func _on_anim_seashell_animation_finished(anim_name):
	if anim_name == 'Dead':
		queue_free()
	if anim_name == 'Fire':
		var pearl_instance = pearl_scene.instantiate()
		add_child(pearl_instance)
		pearl_instance.position = $ray_attack.position
		
		if rotation_degrees == 180 or rotation_degrees == -180:		
			pearl_instance.speed *= -1 if is_right_direction else 1
			pearl_instance.scale.x = 1 if $ray_attack.target_position.x > 0 else -1
		else:		
			pearl_instance.speed *= 1 if is_right_direction else -1
			pearl_instance.scale.x = -1 if $ray_attack.target_position.x > 0 else 1


func _on_damage_area_body_entered(body):
	if body.is_in_group('player') and (not is_dead or not is_hurting):
		body.damage(STR)


func _on_attack_timer_timeout():
	is_attacking = false


func _on_hurting_timer_timeout():
	is_hurting = false
