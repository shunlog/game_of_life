extends Button

var GOL : GameOfLife = null

func _input(event):
	if event.is_action_pressed("step"):
		emit_signal("pressed")

func _on_GOLController_GOL_changed(node):
	GOL = node

func _on_ButtonStep_pressed():
	GOL.unpause_one_step()
	
	# notify the Game to pause
	var ev = InputEventAction.new()
	ev.action = "pause"
	ev.pressed = true
	Input.parse_input_event(ev)
