extends CanvasLayer


@export var first_scene : String

# Usado para el reinicio de los stats
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
# Player skills
var skills : Dictionary = {
	'wall_jump' : false, 
	'dash' : false,
	'wide_attack' : false
	}
# Called when the node enters the scene tree for the first time.
func _ready():
	
	PLAYER.set_process(false) 
	CAMERA.set_process(false)
	GUI.set_process(false) 
	GUI.visible = false
	# FadeIN animation
	$Fade_in.play("RESET")
	$Fade_in.play("Fade_in")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):	pass


func _on_start_pressed():
	PLAYER.set_process(true)
	#PLAYER.disable_platform_check()
	PLAYER.visible = true
	CAMERA.set_process(true)
	GUI.set_process(true)
	GUI.visible = true
	GUI.reset_gui()
	GAME_MANAGER.stats = stats
	GAME_MANAGER.skills = skills
	GAME_MANAGER._current_XP = 0
	GAME_MANAGER._current_LV = 1
	
	get_tree().change_scene_to_file(first_scene)
	get_tree().paused = false
	

func _on_continue_pressed():
	GAME_MANAGER.load_data()
	PLAYER.set_process(true)
	#PLAYER.disable_platform_check()
	PLAYER.visible = true
	CAMERA.set_process(true)
	GUI.set_process(true)
	GUI.visible = true
	GUI.reset_gui()	
	
	PLAYER.position = GAME_MANAGER.location.last_checkpoint + (Vector2.UP * 10)
	GAME_MANAGER.is_loaded_from_disk = true
	#print('GAME_MANAGER checkpoint_scene: ' + str(GAME_MANAGER.location.checkpoint_scene))
	get_tree().change_scene_to_file(GAME_MANAGER.location.checkpoint_scene)
	get_tree().paused = false
	
	
func _on_exit_pressed():
	get_tree().quit()
	print('Hola desde exit')


func _on_fade_in_animation_finished(anim_name):
	if anim_name == 'Fade_in':
		pass
		

func _on_options_pressed():
	$Options_popup.visible = true


func _on_controls_pressed():
	$Controls.visible = true
