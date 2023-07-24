extends CharacterBody2D
# Velocidades
# Seria bueno arreglar esto con un diccionario pero no es posible
@export var dash_speed : int = 200
@export var hit_speed : int = 45
@export var walk_speed : int = 128
@export var jump_velocity : int = -300
@export var bouncing_jump : int = -256 # Esta es la fuerza de rebote de las paredes
@export var extra_force_jump : = 7
# Distancia de detecion de enemigo
const CAST_ENEMY : int = 32
# Comprobaciones de acciones

# Creo es conveniente un diccionario
var status : Dictionary = {
	'can_move': false,
	'is_hurting': false,
	'is_attacking' : false,
	'coyote_time': false,
	'can_dash' : false,
	'dashing' : false,
	'platform_check_is_active': true
	}

# states : 'normal, 
# poison(debilita la fuerza, reduce salud), 
# petrify(paraliza al personaje), 
# maldito(desactiva el ataque o habilidades)
var state : String = 'normal' # Esto debe ser una lista
var is_altered_state = false
# Contador de saltos
var jump_counter : int = 0

# Stats
@export var health : int = 100
var vertical_direction : float = 0
var direction : float = 0
var facing : int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var slash_scene : PackedScene

# STATE MACHINE
@onready var playback : AnimationNodeStateMachinePlayback = $anim_tree.get("parameters/playback")

func _ready():
	
	$anim_tree.active = true
	# OJO aqui: El personaje no debe actualizar la salud al cargar
	GAME_MANAGER.stats.HP = health 


func _physics_process(delta):
	
	if Input.is_action_just_pressed('Pause'):
		GUI.pause()
	if Input.is_action_just_pressed('Map'):
		GUI.map()
	
	altered_state_control()
	
	# Add friction on wall
	if is_on_wall_only() and velocity.y >= -16 and GAME_MANAGER.skills['wall_jump']:
		velocity.y += gravity/8 * delta
		
		if not status.coyote_time:
			$coyote_time.start()
			status.coyote_time = true
		
	# Add the gravity.
	elif not is_on_floor() and not status.dashing:		
		velocity.y += gravity * delta	
		# Un impulso extra para el salto
		if Input.is_action_pressed("Jump") and playback.get_current_node() == 'Jump':
			velocity.y -= extra_force_jump
			
		
	# Reinicia el contador de saltos
	if is_on_ceiling(): jump_counter = 1
	elif is_on_floor() or not is_on_wall_only():jump_counter = 0
		
	# Variables de direccion y facing
	vertical_direction = Input.get_axis("ui_down", "ui_up")
	status.can_move = not status.is_attacking or not status.dashing # dash anim
	if status.can_move:
		direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		facing = -1
	elif direction == 1:
		facing = 1
	
	cross_platform()
	
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor())and vertical_direction != -1 and not status.dashing:
		velocity.y = jump_velocity
		$Jump.play()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		

	
	if not status.is_hurting and not status.dashing:
		velocity.x = direction * walk_speed if direction and status.can_move else move_toward(velocity.x, 0, walk_speed)
		
	# Emision de particulas de polvo
	if direction != 0:
		$Dust.emitting = is_on_floor() or is_on_wall_only()
		
	animation_control()	
	ray_attack_control()
	if Input.is_action_just_pressed('Attack'):		attack()	
	move_and_slide()
	
	status.can_dash = not status.dashing #and is_on_floor()
	# la condicion es que no este en dash y que no se ejecute en el aire
	if Input.is_action_just_pressed("Dash"):dash_control()
	if GAME_MANAGER.skills['wall_jump']:wall_jump()

func altered_state_control():
	if is_altered_state == false and state != 'normal':
		
		if PLAYER.state in ['poisoned','petrified','cursed']:
			$state_effect_timer.start()
			print('player state: ' + state)
		is_altered_state = true
		
func dash_control():
	if is_on_floor_only() and status.can_dash and GAME_MANAGER.skills['dash']:
		playback.travel('Hit') # Funciona solo despues de move_and_slide
		status.dashing = true
		status.can_dash = false
		
		$dash_time.start()
		$dash_sfx.play()
		# move_toward(velocity.x, 0, dash_speed * facing) # solo un poco mas responsivo
		velocity.x = dash_speed * facing
		velocity.y = -10	
	
func cross_platform():
	'''
	Mecanica que permite al personaje traspasar plataformas sobre las que se apoya
	Nota: funciona en conjunto con disable_pltform_check
	'''
	# hace un conteo de las colisiones sobre las que el personaje esta tocando
	var slide_count = get_slide_collision_count()	
	
	if slide_count:
		
		# Obtiene la colider para saber si pertenece al grupo de plataformas traspasables
		var collider = get_slide_collision(slide_count -1).get_collider()
		
		if collider:
			if status.platform_check_is_active:
				if  collider.is_in_group('platform') and vertical_direction == -1 and Input.is_action_just_pressed('Jump'):
					$capsule.disabled = true
					$platform_timer.start()
					
func disable_platform_check():
	status.platform_check_is_active = false
	$platform_check.start()

# Funcion a eliminar proximamente
func emit_blood():
	$Blood.emitting = true
	$Blood.process_material.direction.x = 10 if facing else -10
	
func damage(hit_damage : int = 1):
	
	var base_damage = hit_damage - GAME_MANAGER.stats.DEF
	var random_damage = randi_range(-2,2)
	var total_damage = base_damage + random_damage
	
	print('hit_damage: ' + str(hit_damage) + ' def: ' + str(GAME_MANAGER.stats.DEF) + ' base_damage: ' + str(base_damage) + ' random_damage: ' + str(random_damage) + ' total_damage: ' + str(total_damage))
	
	if total_damage <= 0:
		total_damage = 0
	
	if not status.is_hurting:
		GAME_MANAGER.stats.HP -= total_damage		
		status.is_hurting = true
		velocity.x = hit_speed * -facing
		$damage_timer.start()
		playback.travel('Hit')
		CAMERA.counter = 30
		CAMERA.power = 5
		
		emit_blood()

func ray_attack_control():
	status.is_attacking = playback.get_current_node() in ['Attack1', 'Attack2', 'Attack3']
	$ray_attack.enabled = status.is_attacking
	$ray_attack.target_position.x = CAST_ENEMY * facing
	
	var body = $ray_attack.get_collider()
	if $ray_attack.is_colliding() and body.is_in_group('enemy') and status.is_attacking:
		body.damage(GAME_MANAGER.stats.STR)

func attack():	
	# hitSword
	var random_pitch = randf_range(.75,1.15)
	$hit_sword.pitch_scale = random_pitch
	if status.is_attacking: $hit_sword.play()
	
	var attack_dict : Dictionary = {
		'Idle':'Attack1',
		'Run':'Attack1',
		'Attack1':'Attack2',
		'Attack2':'Attack3',			
		'Jump':'Attack3',
		'Fall':'Attack2',
	}
	# Animation
	if playback.get_current_node() in attack_dict:			
		playback.travel(attack_dict[playback.get_current_node()])
			
	# Slash attack
	if status.is_attacking and GAME_MANAGER.skills.wide_attack:
		var effect_instance = slash_scene.instantiate()
		add_child(effect_instance)
		effect_instance.position = $ray_attack.target_position
		effect_instance.scale.x = 1 if $ray_attack.target_position.x > 0 else -1	

func wall_jump():	
	if status.coyote_time and Input.is_action_just_pressed('Jump') and jump_counter < 1:		
		velocity.y = bouncing_jump
		velocity.x = facing * -walk_speed
		jump_counter += 1		

func animation_control():
	if not status.is_hurting:	
		if is_on_floor():
			playback.travel("Idle" if direction == 0 else "Run")		
		else:
			playback.travel("Jump" if velocity.y < 0 else "Fall")			

func _on_damage_timer_timeout():	
	status.is_hurting = false
	velocity.x = 0

func _on_platform_timer_timeout():
	$capsule.disabled = false

func _on_coyote_time_timeout():
	status.coyote_time = false

func _on_dash_time_timeout():
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	status.dashing = false

func _on_platform_check_timeout():
	status.platform_check_is_active = true

func _on_anim_player_animation_finished(_anim_name):
	pass


func _on_state_effect_timer_timeout():
	state = 'normal'
	is_altered_state = false
	

func _on_restore_mp_timer_timeout():
	if state == 'normal':
		GAME_MANAGER.restore_MP(1)
	elif state == 'poisoned':
		GAME_MANAGER.restore_MP(-1)
