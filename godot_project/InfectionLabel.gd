extends Label

var format := "Infectivity: %.2f"

func _on_infectivity_value_changed(value):
	text = format % value
