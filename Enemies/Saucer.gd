extends Base_enemy

@export var amplitude = 5
var direction : int = 1
var time_counter : float = 0
var is_sin : bool
@onready var playback : AnimationNodeStateMachinePlayback = $anim_tree.get("parameters/playback")
# Get the gravity from the project settings to be synced with RigidBody nodes.
func _ready():

	$anim_tree.active = true
	is_sin = randi() % 2 == 0


func _physics_process(delta):
	# Add the gravity.
	time_counter +=1
	$spr_saucer.flip_h = direction == -1
	velocity = Vector2(speed * direction, sin(time_counter * delta) * amplitude) if is_sin else Vector2(speed * direction, cos(time_counter * delta) * amplitude)

	move_and_slide()


func hurt():
	playback.travel('Hurt')
	velocity.x = -300
	$hurt_time.start()

func dead_anim():
	$big_explosion.play()
	$explosion.emitting = true
	playback.travel('Dead')


func _on_damage_area_body_entered(body):
	if body.is_in_group('player') and (not is_dead and not is_hurting):
		body.damage(STR)

func _on_hurt_time_timeout():
	is_hurting = false


func _on_anim_tree_animation_finished(anim_name : String):
	if anim_name == 'Hurt':
		is_hurting = false
		
	elif anim_name == 'Dead':
		is_dead = true
		queue_free()


func _on_autodestroy_timeout():
	queue_free()
