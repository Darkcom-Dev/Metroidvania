extends Area2D

@export var room_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func _on_body_entered(body):
	if body.is_in_group('player') and room_name != '':
		MAP_DATA.current_room = room_name
		MAP_DATA.room_state_dict[room_name] = true
		if room_name in MAP_DATA.room_state_dict:
			print(str(room_name) + ' in MAP_DATA: ' + str(MAP_DATA.room_state_dict[room_name]))			
		else:
			print('asegurese de nombrar bien la variable room_name')
