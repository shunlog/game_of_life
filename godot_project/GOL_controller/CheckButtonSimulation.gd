extends CheckButton

var GOL : GameOfLife = null

func _input(event):
	if event.is_action_pressed("toggle_pause"):
		pressed = !pressed
	if event.is_action_pressed("pause"):
		pressed = false

func _on_GOLController_GOL_changed(node):
	GOL = node
	pressed = !GOL.paused

func _on_CheckButtonSimulation_toggled(pressed):
	GOL.paused = !pressed
