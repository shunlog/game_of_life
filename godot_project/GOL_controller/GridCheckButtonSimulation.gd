extends CheckButton

var GOL : GameOfLife = null

func _input(event):
	if event.is_action_pressed("toggle_grid"):
		pressed = !pressed

func _on_GOLController_GOL_changed(node):
	GOL = node
	pressed = GOL.grid_visible

func _on_GridCheckButton_toggled(pressed):
	GOL.grid_visible = pressed
