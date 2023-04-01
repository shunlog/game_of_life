extends Control

signal GOL_changed(node)

onready var GOL :GameOfLife setget set_GOL

func set_GOL(v):
	GOL = v
	emit_signal("GOL_changed", GOL)
