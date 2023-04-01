extends Button


func _input(event):
	if event.is_action_pressed("step"):
		_pressed()
		emit_signal("pressed")

func _pressed():
	var ev = InputEventAction.new()
	ev.action = "pause"
	ev.pressed = true
	Input.parse_input_event(ev)
