extends Node

const MAPFILE : String = 'user://MAPFILE.save'

var room_state_dict : Dictionary = {
	'level_movement' : false,
	'level_jumps' : false,
	'level_jumps_complex_A': false,
	'level_jumps_complex_B': false,
	'level_jumps_and_boxes_A': false,
	'level_jumps_and_boxes_B' : false,
	'level_sword_range_A' : false,
	'level_sword_range_B' : false,
	'level_sword_range_C' : false,
	'level_sword_range_D' : false,
	'level_4': false,
	'level_4_2': false,
	'level_3': false,
	'level_2': false,
	'level_1B': false,
	'level_1A': false
}

var current_room : String

func load_data():
	var file = FileAccess.open(MAPFILE,FileAccess.READ)
	if file == null:
		save_data()
	else:
		var full_data = file.get_var()
		print(full_data)
		room_state_dict = full_data
		
	file = null
	
func save_data():
	var file = FileAccess.open(MAPFILE, FileAccess.WRITE)
	var full_data : Dictionary = room_state_dict
	file.store_var(full_data)
	file = null
