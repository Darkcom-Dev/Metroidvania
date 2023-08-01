extends CanvasLayer

@export var first_scene : String

func reset_position_player():
	PLAYER.set_process(false)
	PLAYER.reset_character()
	PLAYER.visible = false
	PLAYER.set_process(true)
	CAMERA.position = PLAYER.position
	print_debug(PLAYER.global_position)

func _ready():
	reset_position_player()
	PLAYER.set_process(false) 
	CAMERA.set_process(false)
	GUI.set_process(false) 
	GUI.visible = false
	# FadeIN animation
	$Fade_in.play("RESET")
	$Fade_in.play("Fade_in")
	$VBoxContainer2/Menu/Start.grab_focus()
		
func restart_GUI():
	# GUI
	GUI.set_process(true)
	GUI.visible = true
	GUI.reset_gui()

func load_scene(scene : String):
	get_tree().change_scene_to_file(scene)
	print('loaded_scene: ' + str(scene))
	get_tree().paused = false

func restart_player(pos : Vector2):
	#Player
	PLAYER.set_process(true)
	PLAYER.visible = true
	PLAYER.global_position = pos

func _on_start_pressed():
	restart_player(PLAYER.global_position)
	CAMERA.set_process(true)
	restart_GUI()
	# Stats
	GAME_MANAGER.restart_data(false)
	load_scene(first_scene)	

func _on_continue_pressed():
	restart_player(GAME_MANAGER.location.last_checkpoint + (Vector2.UP * 10))
	CAMERA.set_process(true)
	# GUI
	restart_GUI()	
	GAME_MANAGER.restart_data(true)
	load_scene(GAME_MANAGER.location.checkpoint_scene)	
	
func _on_exit_pressed():
	get_tree().quit()
	
func _on_options_pressed():
	$Options_popup.visible = true

func _on_controls_pressed():
	$Controls.visible = true
