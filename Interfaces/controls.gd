extends Popup

func _on_popup_hide():
	get_tree().paused = false
	visible = false

func _on_button_pressed():
	get_tree().paused = false
	visible = false


func _on_focus_entered():
	$Background/MarginContainer/VBoxContainer/close.grab_focus()
