extends Control

signal GOL_changed(node)
signal center_camera()

onready var GOL :GameOfLife setget set_GOL

func set_GOL(v):
	GOL = v
	emit_signal("GOL_changed", GOL)

func _on_GOLPresetsOptionButton_GOL_changed(node):
	if not GOL:
		yield(self, "ready")
	self.GOL = node


func _on_CenterCameraButton_button_down():
	emit_signal("center_camera")
