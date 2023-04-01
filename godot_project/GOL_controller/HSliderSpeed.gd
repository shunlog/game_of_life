extends HSlider

var GOL : GameOfLife = null

func set_value(v):
	value = v
	emit_signal("value_changed", v)

func _on_GOLController_GOL_changed(node):
	GOL = node
	value = GOL.fps

func _on_HSliderSpeed_value_changed(value):
	GOL.fps = value
