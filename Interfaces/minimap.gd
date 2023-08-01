extends Popup

func unpause():
	get_tree().paused = false
	visible = false

func _on_close_pressed():
	unpause()
	
func _on_popup_hide():
	unpause()
	
func _ready():
	$MarginContainer/close.grab_focus()


func _on_focus_entered():
	$MarginContainer/close.grab_focus()
