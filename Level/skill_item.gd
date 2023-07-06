extends Area2D

@export var skill : String 
@export var message : String
# Called when the node enters the scene tree for the first time.
func _ready():
	if GAME_MANAGER.skills[skill]:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):	pass


func _on_body_entered(body):
	
	if body.is_in_group('player'):
		GAME_MANAGER.skills[skill] = true
		$pause_timer.start()
		GUI.set_skill_message(message)
		# TODO: Add Skill Sound
	


func _on_pause_timer_timeout():
	
	queue_free()
