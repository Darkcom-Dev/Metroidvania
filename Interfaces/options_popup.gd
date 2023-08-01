extends Popup

var first_time : bool = true
var bgm_index : int
var sfx_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	bgm_index = AudioServer.get_bus_index('BGM')
	sfx_index = AudioServer.get_bus_index('SFX')
	print('bgm: ' + str(bgm_index) + ' sfx: ' + str(sfx_index))
	load_data()
	$BG_popup/MarginContainer/VBoxContainer/HBox_VSinc/Accept.grab_focus()
	
func _process(_delta):
	$BG_popup/MarginContainer/VBoxContainer/HBox_BGM_Volume/bgm_vol.text = str($BG_popup/MarginContainer/VBoxContainer/HBox_BGM_Volume/bgm_slider.value) + ' db'
	$BG_popup/MarginContainer/VBoxContainer/HBox_SFX_Volume/sfx_vol.text = str($BG_popup/MarginContainer/VBoxContainer/HBox_SFX_Volume/sfx_slider.value) + ' db'

func _on_bgm_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bgm_index, value)
	GAME_OPTIONS.options.bgm_volume = value

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_index, value)
	GAME_OPTIONS.options.sfx_volume = value

func _on_menu_button_item_selected(index):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if index == 0 else DisplayServer.WINDOW_MODE_FULLSCREEN)
	GAME_OPTIONS.options.mode = index

func _on_check_button_toggled(button_pressed):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if button_pressed else DisplayServer.VSYNC_DISABLED)
	GAME_OPTIONS.options.vsync = button_pressed

func _on_accept_pressed():
	GAME_OPTIONS.save_data()
	visible = false

func _on_popup_hide():
	GAME_OPTIONS.save_data()
	
func load_data():
	
	GAME_OPTIONS.load_data()
	
	if first_time:
		AudioServer.set_bus_volume_db(bgm_index, GAME_OPTIONS.options.bgm_volume)
		AudioServer.set_bus_volume_db(sfx_index, GAME_OPTIONS.options.sfx_volume)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if GAME_OPTIONS.options.mode == 0 else DisplayServer.WINDOW_MODE_FULLSCREEN)
		#Vsync genera problemas al personaje
#		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if GAME_OPTIONS.options.vsync else DisplayServer.VSYNC_DISABLED)
#	
		$BG_popup/MarginContainer/VBoxContainer/HBox_BGM_Volume/bgm_slider.value = GAME_OPTIONS.options.bgm_volume
		$BG_popup/MarginContainer/VBoxContainer/HBox_SFX_Volume/sfx_slider.value = GAME_OPTIONS.options.sfx_volume
		$BG_popup/MarginContainer/VBoxContainer/HBox_Mode/MenuButton.selected = GAME_OPTIONS.options.mode
#		$HBoxContainer/Controls/CheckButton.toggle_mode = GAME_OPTIONS.options.vsync
	
		$BG_popup/MarginContainer/VBoxContainer/HBox_BGM_Volume/bgm_vol.text = str($BG_popup/MarginContainer/VBoxContainer/HBox_BGM_Volume/bgm_slider.value) + ' db'
		$BG_popup/MarginContainer/VBoxContainer/HBox_SFX_Volume/sfx_vol.text = str($BG_popup/MarginContainer/VBoxContainer/HBox_SFX_Volume/sfx_slider.value) + ' db'
		first_time = false
	
	


func _on_focus_entered():
	$BG_popup/MarginContainer/VBoxContainer/HBox_VSinc/Accept.grab_focus()
