extends HSlider

func set_value(v):
	value = v
	emit_signal("value_changed", v)
