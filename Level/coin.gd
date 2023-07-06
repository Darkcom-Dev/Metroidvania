extends Area2D

var is_active : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():	pass # Replace with function body.


func _on_body_entered(body):
	if body.is_in_group('player') and is_active:
		$anim_coin.play("effect")
		$coin_sfx.play()
		GAME_MANAGER.stats.coins += 1
		is_active = false

func _on_coin_sfx_finished():
	queue_free()
