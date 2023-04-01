extends HSlider

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	value = GOL.pen_randomness

func _on_PenOpacityHSlider_value_changed(value):
	GOL.pen_randomness = value
