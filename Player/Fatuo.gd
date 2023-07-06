extends Node2D

@export var speed : int
@export var mp_consumption : int
@export var offset : Vector2
@export var bullet_scene : PackedScene

var can_shoot : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$shoot_timer.start()
	can_shoot = false
	$anim_fatuo.play('Idle')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	$spr_fatuo.flip_h = PLAYER.facing == 1
	var _offset = Vector2(offset.x * PLAYER.facing, offset.y)
	position = lerp(position, PLAYER.position + _offset, delta * speed)
	var vertical_direction = Input.get_axis("ui_down", "ui_up")
	if Input.is_action_pressed('Attack') and vertical_direction == 1:
		shoot()

func shoot():
	if can_shoot and GAME_MANAGER.stats.MP >= mp_consumption:
		
		$shoot_timer.start()
		can_shoot = false
		var bullet_instance = bullet_scene.instantiate()
		GAME_MANAGER.stats.MP -= mp_consumption
		bullet_instance.position = position
		bullet_instance.direction = PLAYER.facing
		
		get_parent().add_child(bullet_instance)
	

func _on_shoot_timer_timeout():
	can_shoot = true
