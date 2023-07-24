extends Sprite2D

var state_color_dict : Dictionary = {
	'poisoned': '#00ff00',
	'petrified': '#808080',
	'cursed':'#ff00ff',
	'normal': '#ffffff'
}

# Called when the node enters the scene tree for the first time.
#func _ready():	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	flip_h = get_parent().facing < 0
	self_modulate = state_color_dict[get_parent().state]
