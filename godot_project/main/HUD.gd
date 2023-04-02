extends Control

signal GOL_changed(node)

onready var GOL :GameOfLife setget set_GOL

func set_GOL(v):
	GOL = v
	emit_signal("GOL_changed", GOL)

func _on_GOLPresetsOptionButton_GOL_changed(node):
	if not GOL:
		yield(self, "ready")
	self.GOL = node


func _on_LoadBitmapButton_pressed():
	pass # Replace with function body.
