extends Area2D

@export var STR : int
@export var attack_anim_name : String
@export var target_group : String

func _on_anim_tooth_animation_finished(anim_name):
	if anim_name == attack_anim_name:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group(target_group):
		body.damage(STR if target_group == 'enemy' else GAME_MANAGER.stats.STR)
