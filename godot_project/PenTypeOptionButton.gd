extends OptionButton

signal pen_type_changed(id)

func _ready():
	pass

func _on_PenTypeOptionButton_item_selected(index):
	emit_signal("pen_type_changed", get_item_id(index))
