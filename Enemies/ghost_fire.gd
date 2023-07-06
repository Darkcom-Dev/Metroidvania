extends Base_enemy

func _ready():
	$anim_ghost.play_backwards("Dead")


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var diference : Vector2 = PLAYER.global_position - global_position
	var facing : bool = diference.x >= 0	
	$spr_ghost.flip_h = facing
	
	if not is_hurting:
		global_position = lerp(global_position, PLAYER.global_position, delta * speed)

	move_and_slide()

func hurt():
	$anim_ghost.play("Hit")
	velocity.x = -hit_speed if $spr_ghost.flip_h else hit_speed
	velocity.y = -1

func dead_anim():
	$anim_ghost.play("Dead")
	is_dead = true

func _on_anim_ghost_animation_finished(anim_name : String):
	if anim_name == 'Dead' and not is_dead:
		$anim_ghost.play('Idle')
		
	elif anim_name == 'Dead' and is_dead:
		queue_free()
		
	if anim_name == 'Hit':
		is_hurting = false
		$anim_ghost.play("Idle")


func _on_hit_area_body_entered(body):
	if body.is_in_group('player') and (not is_dead or not is_hurting):
		body.damage(STR)
