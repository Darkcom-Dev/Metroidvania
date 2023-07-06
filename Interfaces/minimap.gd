extends Popup

func _on_close_pressed():
	get_tree().paused = false
	visible = false


func _on_popup_hide():
	get_tree().paused = false
	visible = false
