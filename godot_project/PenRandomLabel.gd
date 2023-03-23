extends Label

var format := "Random: %.1f"

func _on_HSlider2_value_changed(value):
	text = format % value
