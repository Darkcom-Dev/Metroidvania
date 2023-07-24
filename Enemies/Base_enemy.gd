extends CharacterBody2D

class_name Base_enemy

@export var speed = 300.0
@export var hit_speed = -400.0
@export_category('Stats')
@export var health : int = 5
@export var STR : int = 10
@export var DEF = 1 # Para calculos de daño
@export var XP : int = 5

@export_category('Drops')
@export var drop_1 : PackedScene
@export var rarity1 : int
@export var drop_2 : PackedScene
@export var rarity2 : int


var is_dead : bool = false
var is_hurting : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func damage(HP : int = 1):
	"""
	Funcion generica de daño
	"""
	
	var base_damage = HP - DEF
	var random_damage = randi_range(-2, 2)
	var total_damage = base_damage + random_damage
	
	if total_damage <= 0:
		total_damage = 0
	
	if not is_hurting:
		if health > 0:
			health -= total_damage
			print('Health left: ' + str(health))
			hurt()
		else:			
			health = 0
			dead()
		is_hurting = true

func hurt():
	"""
	Esta es una funcion vacia que debe ser rellenada por cada hijo
	"""
	pass

func dead():
	"""
	Funcion generica de muerte
	"""
	
	if not is_dead:
		is_dead = true
		GAME_MANAGER.stats.XP += XP
		print(str(get_collision_mask_value(2)))
		set_collision_mask_value(2, false)
		print('is Dead' + str(get_collision_mask_value(2)))
		drop()
		dead_anim()
		
	
func drop():
	"""
	Funcion de dropeo de recompensas
	"""
	var drop_instance
	# tasa de dropeo
	var drop_rate1 : float = float(GAME_MANAGER.stats.LCK * rarity1) / 1000.0 
	var drop_rate2 : float = float(GAME_MANAGER.stats.LCK * rarity2) / 1000.0 
	var random_drop : float = randf()
	print('random: ' + str(random_drop) + ' rate1: ' + str(drop_rate1) + ' rate2: ' + str(drop_rate2))
	if random_drop < drop_rate2 and drop_2 != null:
		drop_instance = drop_2.instantiate()
		
	elif random_drop < drop_rate1 and drop_1 != null:
		drop_instance = drop_1.instantiate()

			
	if drop_instance != null:
		print(str(drop_instance.name) + ' has been dropped')
			
		var enemy_global_pos = global_transform.origin
		drop_instance.global_position = enemy_global_pos
		get_tree().get_root().call_deferred('add_child',drop_instance)

func dead_anim():
	"""
	Esta es una funcion de animacion vacia para ser rellenada por cada hijo
	"""
	pass

func movement_control(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = 1 # Input.get_axis("ui_left", "ui_right")
	if direction:	velocity.x = direction * speed
	else:		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
