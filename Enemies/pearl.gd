extends Base_enemy

@export var is_left_direction : bool
# Get the gravity from the project settings to be synced with RigidBody nodes.
var direction : int = 1

func _ready():
	direction = -1 if is_left_direction else 1

func _physics_process(_delta):
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

		
func hurt():
	print('hurt desde pearl')
	is_hurting = false

func dead_anim():
	print('Dead anim desde pearl')
	$explosion.emitting = true
	$dead_timer.start()
	$explosion_sfx.play()
	$pearl_anim.play("dead")


func _on_damage_area_body_entered(body):
	if body.is_in_group('player') and (not is_dead or not is_hurting):
		body.damage(STR)
		dead_anim()


func _on_dead_timer_timeout():
	queue_free()

func _on_autodestruct_timeout():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
