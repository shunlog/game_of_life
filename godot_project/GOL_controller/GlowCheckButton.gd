extends CheckButton

var GOL : GameOfLife = null

func _input(event):
	if event.is_action_pressed("toggle_glow"):
		pressed = !pressed

func _on_GOLController_GOL_changed(node):
	GOL = node
	pressed = GOL.glow

func _on_GlowCheckButton_toggled(pressed):
	GOL.glow = pressed
