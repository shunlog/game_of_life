extends ColorPickerButton

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	color = GOL.colors[2]

func _on_InfectedColorPickerButton_color_changed(color):
	GOL.set_color(2, null, color)
