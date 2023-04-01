extends Button

var GOL : GameOfLife = null

func _input(event):
	if event.is_action_pressed("random_fill"):
		emit_signal("pressed")

func _on_GOLController_GOL_changed(node):
	GOL = node

func _on_FillButton_pressed():
	GOL.random_fill()
