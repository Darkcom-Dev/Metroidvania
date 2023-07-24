extends Base_enemy
# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#restrict_move()
	move_and_slide()
	
func restrict_move():
	
	if is_on_wall() and get_last_slide_collision().get_collider().name == 'TileMap':
		set_collision_layer(1)
	else:
		set_collision_layer(0)
	
		
func hurt():
	$anim_box.play("Hit")
	#$hurt_time.start()
	
func dead_anim():
	#PLAYER.disable_platform_check()
	$anim_box.play("Destroy")
	$parteA.emitting = true
	$parteB.emitting = true
	$parteC.emitting = true
	$parteD.emitting = true

func _on_anim_box_animation_finished(anim_name):
	if anim_name == 'Destroy':
		
		queue_free()
	if anim_name == 'Hit':
		$anim_box.play('idle')
		is_hurting = false

func _on_hurt_time_timeout():
	is_hurting = false
