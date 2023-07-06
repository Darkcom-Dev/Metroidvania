extends Base_enemy


@export var counterclockwise : bool = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var counter = 60

@onready var playback : AnimationNodeStateMachinePlayback = $anim_tree.get("parameters/playback")

func _ready():
	$anim_tree.active = true
	playback.travel("Walk")
	$movement_timer.start()

func hurt():
	playback.travel('Hurt')
	#velocity.x = 1 * hit_speed # por conveniencia es mejor desactivarlo
	$damage_timer.start()

func dead_anim():
	$sfx.play()
	playback.travel('Dead')
	

func _physics_process(_delta):
	
		
	# Get the input counterclockwise and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	if counterclockwise:
		$spr_python.flip_h = true		
	else:
		$spr_python.flip_h = false
		
	
	if $horizontal.is_colliding():
		counterclockwise = not counterclockwise
		$spr_python.flip_h = not $spr_python.flip_h
		$horizontal.target_position.x = -16 if counterclockwise else 16

	counter = 60 if $vertical.is_colliding() else counter -1	
	
	if $vertical.is_colliding():
		if rotation_degrees == 0 or rotation_degrees == 360:
			velocity = Vector2.LEFT * speed if counterclockwise else Vector2.RIGHT * speed
		elif rotation_degrees == 90 or rotation_degrees == -270:
			velocity = Vector2.UP * speed if counterclockwise else Vector2.DOWN * speed
		elif rotation_degrees == 180 or rotation_degrees == -180:
			velocity = Vector2.RIGHT * speed if counterclockwise else Vector2.LEFT * speed
		elif rotation_degrees == -90 or rotation_degrees == 270:
			velocity = Vector2.DOWN * speed if counterclockwise else Vector2.UP * speed
	else:
		if counter == 0:
			if rotation_degrees == 0 or rotation_degrees == 360:
				rotation_degrees = -90 if counterclockwise else 90
				velocity = Vector2.DOWN * speed
			elif rotation_degrees == 90 or rotation_degrees == -270:
				rotation_degrees = 0 if counterclockwise else 180
				velocity = Vector2.LEFT * speed
			elif rotation_degrees == 180 or rotation_degrees == -180:				
				rotation_degrees = 90 if counterclockwise else -90
				velocity = Vector2.UP * speed
			elif rotation_degrees == -90 or rotation_degrees == 270:
				rotation_degrees = -180 if counterclockwise else 0
				velocity = Vector2.RIGHT * speed
		
	move_and_slide()


func _on_damage_timer_timeout():
	
	is_hurting = false
	velocity.x = 0

func _on_movement_timer_timeout():
	$movement_timer.start()

func _on_hitbox_body_entered(body):
	if body.is_in_group('player') and (not is_dead or not is_hurting):
		body.damage(STR)
		body.state = 'poisoned'

func _on_anim_tree_animation_finished(anim_name):
	if anim_name == 'Dead':
		queue_free()
