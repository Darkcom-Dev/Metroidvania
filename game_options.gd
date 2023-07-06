extends Node

const OPTIONS_FILE : String = 'user://OPTIONSFILE.save'

var options : Dictionary = {
	'mode' : 0,
	'vsync': true,
	'bgm_volume' : 0,
	'sfx_volume' : 0
}

func save_data():
	var file = FileAccess.open(OPTIONS_FILE, FileAccess.WRITE)
	var full_data : Dictionary = {
		'options':options,
	}
	file.store_var(full_data)
	file = null

func load_data():
	var file = FileAccess.open(OPTIONS_FILE, FileAccess.READ)
	if file == null:
		save_data()
	else:
		var full_data = file.get_var()
		print(full_data)
		options = full_data.options
	file = null
