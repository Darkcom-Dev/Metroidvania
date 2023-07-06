extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	else:
		collision_layer = 0

	move_and_slide()


func _on_coin_dropeable_tree_exited():
	queue_free()


func _on_autodestruct_timeout():
	queue_free()
