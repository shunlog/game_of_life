extends Label

var format := "Speed: %.2f"

func _ready():
	pass

func _on_HSliderSpeed_value_changed(value):
	text = format % value
