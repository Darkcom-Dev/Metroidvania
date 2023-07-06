extends Area2D

@export var HP : int = 20
@export var effect : PackedScene

# Called when the node enters the scene tree for the first time.
#func _ready():	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):	pass


func _on_body_entered(body):
	# TODO: audio de recoleccion de items
	# TODO: recolection effect
	if body.is_in_group('player'):
		GAME_MANAGER.restore_health(HP)
		print(str(HP) + ' Restored')
		$coin_audio.play()
		queue_free()
