extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$anim_explosion.play("Explosion")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):	pass


func _on_explosion_finished():
	queue_free()
