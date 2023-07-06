extends Area2D

@onready var player : CharacterBody2D = get_tree().get_nodes_in_group('player')[0]
const SPEED = 100
var direction : int
var can_move : bool = true
@export var explosion_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#$anim_bullet.play('Bullet')
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$spr_bullet.flip_h = direction == -1	
	position.x += (direction * SPEED) * delta if can_move else 0

func _on_Visible_screen_exited():
	print(name + 'Salió de la pantalla')
	queue_free()


func _on_Shoot_body_entered(body):
	
	can_move = false
	var explosion_instance = explosion_scene.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.position = position
	#explosion_instance.reparent(get_parent())
	if body.is_in_group('enemy'):		
		print('body_name: ' + body.name + ' body_group: ' + str(body.get_groups()))
		body.damage(GAME_MANAGER.stats.INT)
		queue_free()
	if body.name == 'tilemap':
		queue_free()


func _on_timer_timeout():
	queue_free()
