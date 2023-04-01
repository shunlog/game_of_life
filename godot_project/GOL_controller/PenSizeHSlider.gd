extends HSlider

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	value = GOL.pen_size

func _on_PenSizeHSlider_value_changed(value):
	GOL.pen_size = value
