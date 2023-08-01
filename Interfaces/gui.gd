extends CanvasLayer

var first_time = true

# Called when the node enters the scene tree for the first time.
func update():
	$MarginContainer/Container/Coins/coin_counter.text = 'x ' + str(GAME_MANAGER.stats.coins)
	$MarginContainer/Container/Health_bar/health_bar_progress.value = GAME_MANAGER.stats.HP
	$MarginContainer/Container/Health_bar/health_bar_progress.max_value = GAME_MANAGER.stats.max_HP
	$MarginContainer/Container/Health_bar/MP_bar_progress.value = GAME_MANAGER.stats.MP
	$MarginContainer/Container/Health_bar/MP_bar_progress.max_value = GAME_MANAGER.stats.max_MP
	$MarginContainer/Container/pos.text = 'pos.' + str(PLAYER.position) 
	
	if GAME_MANAGER.stats.HP <= 0 and first_time:
		$GameOver_fadein.play("FadeIn")
		$Timer.stop()
		get_tree().paused = true
		first_time = false

func map():
	get_tree().paused = true
	$Minimap_Popup.visible = true

func pause():
	get_tree().paused = true
	$Pause.visible = true
	
	$Pause/Panel/Margin_pause/VBoxContainer/Stats/HP_maxHP.text = 'HP: ' + str(GAME_MANAGER.stats.HP) + ' / ' + str(GAME_MANAGER.stats.max_HP)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats/MP_maxMP.text = 'MP: ' + str(GAME_MANAGER.stats.MP) + ' / ' + str(GAME_MANAGER.stats.max_MP)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats/LV.text = 'LEVEL : ' + str(GAME_MANAGER.stats.LV)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats/Next_LV.text = 'Next LV: ' + str(GAME_MANAGER.stats.max_XP)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats/XP.text = 'XP: ' + str(GAME_MANAGER.stats.XP)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats/Coins.text = '$: ' + str(GAME_MANAGER.stats.coins)
	
	$Pause/Panel/Margin_pause/VBoxContainer/Stats2/STR.text = 'STR: ' + str(GAME_MANAGER.stats.STR)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats2/DEF.text = 'DEF: ' + str(GAME_MANAGER.stats.DEF)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats2/INT.text = 'INT: ' + str(GAME_MANAGER.stats.INT)
	$Pause/Panel/Margin_pause/VBoxContainer/Stats2/LCK.text = 'LCK: ' + str(GAME_MANAGER.stats.LCK)
	
	$Pause/Panel/Margin_pause/VBoxContainer/Menu/Resume.grab_focus()

func reset_gui():
	$GameOver_fadein.play("RESET")
	$Timer.start()
	first_time = true
	
func set_skill_message(message : String):
	$Message.visible = true
	$Message/ColorRect/skill_message.text = message
	#TODO: Agregar sonido new_skill_SFX
	$message_timer.start()
	get_tree().paused = true

func _on_timer_timeout():
	update()
	$Timer.start()

func goto_main_menu_scene():
	get_tree().change_scene_to_file('res://Interfaces/main_menu.tscn')		
	set_process(false)

func _on_game_over_fadein_animation_finished(anim_name):
	if anim_name == 'FadeIn':
		goto_main_menu_scene()		
		$GameOver_fadein.stop()

func _on_message_timer_timeout():
	$Message.visible = false
	get_tree().paused = false

func _on_resume_pressed():
	get_tree().paused = false
	$Pause.visible = false

func _on_options_pressed():	
	$Options_popup.visible = true

func _on_main_menu_pressed():
	goto_main_menu_scene()
	get_tree().paused = false
	$Pause.visible = false	
