extends CheckButton

func _ready():
	emit_signal("toggled", pressed)

func _input(event):
	if event.is_action_pressed("toggle_pause"):
		pressed = !pressed
	if event.is_action_pressed("pause"):
		pressed = false
