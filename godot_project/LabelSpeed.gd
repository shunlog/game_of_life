extends Label

var format := "Simulation FPS: %d"

func _ready():
	pass

func _on_HSliderSpeed_value_changed(value):
	text = format % value
