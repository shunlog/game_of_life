extends OptionButton

signal pen_type_changed(id)

func _ready():
	pass

func _on_PenTypeOptionButton_item_selected(index):
	emit_signal("pen_type_changed", get_item_id(index))

func _input(event):
	if event.is_action_pressed("pen_type_alive"):
		_set_selected(0)
	elif event.is_action_pressed("pen_type_dead"):
		_set_selected(1)
	elif event.is_action_pressed("pen_type_infected"):
		_set_selected(2)

func _set_selected(v):
	selected = v
	emit_signal("pen_type_changed", get_item_id(v))
