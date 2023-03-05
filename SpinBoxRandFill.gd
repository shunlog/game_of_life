extends SpinBox

func _ready():
	emit_signal("value_changed", value)
