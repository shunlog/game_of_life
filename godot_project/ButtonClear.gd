extends Button


func _input(event):
	if event.is_action_pressed("clear"):
		emit_signal("button_down")
