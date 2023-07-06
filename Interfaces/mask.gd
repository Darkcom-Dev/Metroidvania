extends TextureRect

@export var reveal : Array
var current_room_node : Node

# Revela porciones del mapa cuando se visita por primera vez y
# colorea la porcion de mapa donde se encuentra el jugador
func update_map():
	
	for room in MAP_DATA.room_state_dict:
		
		if MAP_DATA.room_state_dict[room]:
			var index = reveal.find(NodePath(room))
			var node = get_node(reveal[index])
			node.visible = true
			node.self_modulate = Color.YELLOW if node.name == MAP_DATA.current_room else Color.WHITE

func _on_visibility_changed():
	if visible:
		update_map()
