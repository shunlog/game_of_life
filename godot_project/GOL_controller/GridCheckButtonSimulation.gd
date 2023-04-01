extends CheckButton

func _input(event):
	if event.is_action_pressed("toggle_grid"):
		pressed = !pressed
