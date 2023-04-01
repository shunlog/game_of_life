extends Button


func _input(event):
	if event.is_action_pressed("random_fill"):
		emit_signal("button_down")
