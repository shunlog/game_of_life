extends Label

var format := "Size: %d"

func _on_HSlider_value_changed(value):
	print(value)
	text = format % value
