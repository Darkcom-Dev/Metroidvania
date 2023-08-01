extends Node

const SAVEFILE : String = 'user://SAVEFILE.save'
var is_vertical : bool = false
var is_loaded_from_disk : bool = false

# Player location
var location : Dictionary = {
	'last_scene':'',
	'current_scene':'',
	'player_pos': Vector2.ZERO,
	'checkpoint_scene':'',
	'last_checkpoint':Vector2.ZERO	
}

# Player stats
var stats : Dictionary = {
	'HP':8,
	'max_HP':8,
	'MP':8,
	'max_MP' : 8,
	'XP':1,
	'max_XP':8,
	'LV':1,
	'coins': 0,
	'STR' : 4,
	'DEF' : 4,
	'INT' : 8,
	'LCK' : 8
}

# Formula de subida de nivel en juegos RPG
# Formula exponencial
# ---
# XP para el siguiente nivel = (nivel actual ^ 2) * constante
## Formula lineal - sirve para fuerza, inteligencia, suerte, etc
# XP para el siguiente nivel = nivel actual * constante
 
# Player skills
var skills : Dictionary = {
	'wall_jump' : false, 
	'dash' : false,
	'wide_attack' : false
	} 

var _current_XP : int
var _current_LV : int

const STATS_CONST : Dictionary = {
	'LV' : 8,
	'HP' : 8,
	'MP' : 8,
	'INT': 8,
	'STR': 8,
	'DEF': 8,
	'LCK': 8	
}

# Called when the node enters the scene tree for the first time.
#func _ready():	pass # Replace with function body.

func _process(_delta):
	
	if Input.is_action_just_pressed("Test"): PLAYER.reset_character()
	
	
	if stats.XP != _current_XP:
		stats.max_XP = (stats.LV ** 2) * STATS_CONST.LV
		_current_XP = stats.XP
		if stats.XP >= stats.max_XP:
			stats.LV += 1
			GUI.set_skill_message('Level Up')
			
		if stats.LV != _current_LV:
			stats.max_HP = stats.LV * STATS_CONST.HP
			stats.max_MP = stats.LV * STATS_CONST.MP
			stats.STR = stats.LV * STATS_CONST.STR
			stats.DEF = stats.LV * STATS_CONST.DEF
			stats.INT = stats.LV * STATS_CONST.INT
			stats.LCK = stats.LV * STATS_CONST.LCK

func restore_health(HP: int):	
	stats.HP = stats.max_HP if HP + stats.HP > stats.max_HP else stats.HP + HP		

func restore_MP(MP: int):
	stats.MP = stats.max_MP if MP + stats.MP > stats.max_MP	else stats.MP + MP

func load_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.READ)
	if file == null:
		save_data()
	else:
		var full_data = file.get_var()
		print(full_data)
		location = full_data.location
		stats = full_data.stats
		skills = full_data.skills
	file = null
	
func save_data():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	var full_data : Dictionary = {
		'location':location,
		'stats':stats,
		'skills':skills
	}
	file.store_var(full_data)
	file = null
	
func default_data():
	
	# Usado para el reinicio de los stats
	var default_stats : Dictionary = {
		'HP':8,
		'max_HP':8,
		'MP':8,
		'max_MP' : 8,
		'XP':1,
		'max_XP':8,
		'LV':1,
		'coins': 0,
		'STR' : 4,
		'DEF' : 4,
		'INT' : 8,
		'LCK' : 8
	}
	# Player skills
	var default_skills : Dictionary = {
		'wall_jump' : false, 
		'dash' : false,
		'wide_attack' : false
	}
	_current_XP = 0
	_current_LV = 1
	stats = default_stats
	skills = default_skills

func restart_data(load_from_disk : bool):
	# Es necesario borrar Last-Scene para que el personaje no sea cargado en sitios aleatorios
	# Aun existe un error al accionar el Boton CONTINUE en main menu
	location.last_scene = ''
	is_loaded_from_disk = load_from_disk
	if load_from_disk:
		load_data()
	else:
		default_data()
	
	
