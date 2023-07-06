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
	
	status.can_move = not playback.get_current_node() in ['Attack1', 'Attack2'] or not status.dashing # dash anim
	
	facing = -1 if $spr_player.flip_h else 1
	
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
	if is_on_floor() or not is_on_wall_only():
		jump_counter = 0
		
		
	var vertical_direction = Input.get_axis("ui_down", "ui_up")
	cross_platform(vertical_direction)	
	
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor())and vertical_direction != -1 and not status.dashing:
		velocity.y = jump_velocity
		$Jump.play()
	
	# Execute dash	
	status.can_dash = not status.dashing #and is_on_floor()
	# la condicion es que no este en dash y que no se ejecute en el aire
	if Input.is_action_just_pressed("Dash") and not Input.is_action_just_pressed('Jump'):
		dash_control()
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# can_move = not is_on_wall_only() # Esto es algo inutil
	var direction = 0
	if not status.dashing and not Input.is_action_just_released("Attack"):
		direction = Input.get_axis("ui_left", "ui_right")
	
	if not status.is_hurting and not status.dashing:
		velocity.x = direction * walk_speed if direction and status.can_move else move_toward(velocity.x, 0, walk_speed)
		
	# Emision de particulas de polvo
	if direction != 0:
		$Dust.emitting = is_on_floor() or is_on_wall_only()
	
	
	
	animation_control(direction)
	if GAME_MANAGER.skills['wall_jump']:
		wall_jump(direction)
	
	attack()
	if is_altered_state == false and state != 'normal':
		state_effect() 
		is_altered_state = true
	move_and_slide()

func state_effect():
	if state == 'poisoned':
		$spr_player.self_modulate = '#00ff00'
	elif state == 'petrified':
		$spr_player.self_modulate = '#808080'
	elif state == 'cursed':
		$spr_player.self_modulate = '#ff00ff'
	else:
		$spr_player.self_modulate = '#ffffff'
	if state in ['poisoned','petrified','cursed']:
		$state_effect_timer.start()
		print('player state: ' + state)

func dash_control():
	if is_on_floor_only() and status.can_dash and GAME_MANAGER.skills['dash']:
		playback.travel('Hit') # No funciona
		status.dashing = true
		status.can_dash = false
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		$dash_time.start()
		$dash_sfx.play()	
		velocity.x = -dash_speed if $spr_player.flip_h else dash_speed
		velocity.y = -1
	
	

func cross_platform(vertical):
	'''
	Mecanica que permite al personaje traspasar plataformas sobre las que se apoya
	Nota: funciona en conjunto con disable_pltform_check
	'''
	# hace un conteo de las colisiones sobre las que el personaje esta tocando
	var slide_count = get_slide_collision_count()	
	
	if slide_count:
		
		# Obtiene la colider para saber si pertenece al grupo de plataformas traspasables
		var collider = get_slide_collision(slide_count -1).get_collider()
	
		if status.platform_check_is_active:
			if  collider.is_in_group('platform') and vertical == -1 and Input.is_action_just_pressed('Jump'):
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
		#motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		status.is_hurting = true
		velocity.x = hit_speed if $spr_player.flip_h else -hit_speed
		#velocity.y = -10
		$damage_timer.start()
		playback.travel('Hit')
		CAMERA.counter = 30
		CAMERA.power = 5
		
		emit_blood()

func attack():
	if Input.is_action_just_pressed('Attack'):
		var random_pitch = randf_range(.75,1.15)
		if is_on_floor():			
			$hit_sword.pitch_scale = random_pitch
			if playback.get_current_node() in ['Idle', 'Run']:
				playback.travel('Attack1')	
			elif playback.get_current_node() == 'Attack1':
				playback.travel('Attack2')
				$hit_sword.play()
			elif playback.get_current_node() == 'Attack2':
				playback.travel('Attack3')
				$hit_sword.play()
		elif not is_on_floor():
			if playback.get_current_node() == 'Jump':
				playback.travel('Attack3')
				$hit_sword.play()
			elif playback.get_current_node() == 'Fall':
				playback.travel('Attack2')
				$hit_sword.play()
		
		if playback.get_current_node() in ['Attack1','Attack2', 'Attack3'] and GAME_MANAGER.skills.wide_attack:
			var effect_instance = slash_scene.instantiate()
			add_child(effect_instance)
			effect_instance.position = $ray_attack.target_position
			effect_instance.scale.x = 1 if $ray_attack.target_position.x > 0 else -1
		
	var hit_animation = playback.get_current_node() in ['Attack1', 'Attack2', 'Attack3']
	$ray_attack.enabled = hit_animation
	$ray_attack.target_position.x = -CAST_ENEMY if $spr_player.flip_h else CAST_ENEMY
	
	var body = $ray_attack.get_collider()
	if $ray_attack.is_colliding() and body.is_in_group('enemy') and hit_animation:
		body.damage(GAME_MANAGER.stats.STR)		
	
	
	

func wall_jump(direction):
	
	if status.coyote_time and Input.is_action_just_pressed('Jump') and jump_counter < 1:		
		velocity.y = bouncing_jump
		velocity.x = direction * walk_speed
		jump_counter += 1
		$Dust.emitting = true # No funciona
		

func animation_control(direction):
	# Animation control
	if direction == 1:
		$spr_player.flip_h = false
	elif direction == -1:
		$spr_player.flip_h = true
	else:
		pass
		
	if not status.is_hurting:	
		if is_on_floor():
			playback.travel("Idle" if direction == 0 else "Run")		
		else:
			playback.travel("Jump" if velocity.y < 0 else "Fall")			
	


func _on_damage_timer_timeout():	
#	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
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
	$spr_player.self_modulate = '#ffffff'
	print('player state: NORMALIZED')


func _on_restore_mp_timer_timeout():
	if state == 'normal':
		GAME_MANAGER.restore_MP(1)
	elif state == 'poisoned':
		GAME_MANAGER.restore_MP(-1)
