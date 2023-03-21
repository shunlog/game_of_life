extends Label

var format := "Simulation FPS: %d"

func _on_HSliderSpeed_value_changed(value):
	text = format % value
