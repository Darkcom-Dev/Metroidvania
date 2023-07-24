extends Base_enemy

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : int
var last_direction : int
var can_move
var can_attack = true
var most_be_turn = false

@export var tooth_effect_scene : PackedScene

# STATE MACHINE
@onready var playback : AnimationNodeStateMachinePlayback = $anim_tree.get("parameters/playback")


func _ready():
	$walk_timer.start()

func _physics_process(delta):
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	can_move = false if playback.get_current_node() in ['Attack', 'Hit', 'Dead_hit', 'Dead_ground'] else true
	most_be_turn = not $ray_baston.is_colliding() or is_on_wall()
	
	if can_move and not is_hurting and not is_dead:
		velocity.x = direction * speed
	else:
		#velocity.x = 0
		pass
	if not is_dead: attack()
	motion_control()
	move_and_slide()

func motion_control():
	if direction == 1:
		$spr_fierce.flip_h = true
		$ray_baston.position.x = 16
		$ray_wall.target_position.x = 16
		$ray_attack.target_position.x = 16
	elif direction == -1:
		$spr_fierce.flip_h = false
		$ray_baston.position.x = -16
		$ray_wall.target_position.x = -16
		$ray_attack.target_position.x = -16
	else:
		pass
		
	if abs(velocity.x) > 0 and not is_hurting: playback.travel('Run')
	
	if most_be_turn and direction == 1:
		direction = -1
		velocity.x = speed * -1
		
	elif not $ray_baston.is_colliding() or is_on_wall() and direction == -1:
		direction = 1
		velocity.x = speed


func attack():
	if $ray_attack.is_colliding() and $ray_attack.get_collider().name in ['PLAYER', 'player'] and can_attack:
		playback.travel('Attack')
		can_attack = false
		$attack_timer.start()
		
		var tooth_instance = tooth_effect_scene.instantiate()
		add_child(tooth_instance)
		tooth_instance.position.x = $ray_attack.target_position.x
		tooth_instance.scale.x = -1 if $ray_attack.target_position.x > 0 else 1
		print_debug('target_position' + str($ray_attack.target_position.x))
		

func hurt():
	playback.travel('Hit')
	velocity.x = hit_speed if $spr_fierce.flip_h else -hit_speed
	$damage_timer.start()		

func dead_anim():
	$damage_area.collision_mask = 0
	playback.travel('Dead_hit')
	print('dead_anim')

func _on_idle_timer_timeout():
	if not playback.get_current_node() in ['Dead_hit', 'Dead_ground']:
		if last_direction == 0:
			var int_direction = randi_range(-10, 10)
			direction = 1 if int_direction >=0  else -1
		else:
			direction = last_direction
		$walk_timer.start()
		print('direction: ' + str(direction))


func _on_walk_timer_timeout():
	if not playback.get_current_node() in ['Dead_hit', 'Dead_ground']:
		last_direction = direction
		direction = 0
		$idle_timer.start()
		print('last_direction: ' + str(last_direction))
		playback.travel('Idle')


func _on_attack_timer_timeout():
	can_attack = true


func _on_damage_timer_timeout():
	is_hurting = false	
	velocity.x = 0


func _on_anim_tree_animation_finished(anim_name):
	#TODO: Agregar sonido de muerte
	if anim_name == 'Dead_hit':
		print('Dead_hit')
		queue_free()
		
	if anim_name == 'Hit':
		is_hurting = false
		velocity.x = 0


func _on_damage_area_body_entered(body):
	if body.is_in_group('player') and (not is_dead or not is_hurting):
		body.damage(STR)
