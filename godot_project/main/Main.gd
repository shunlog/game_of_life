extends Node2D

var GOL :GameOfLife = null setget set_GOL
	
func _center_camera():
	$ZoomCamera.center_on_rect(Rect2(GOL.rect_position, GOL.rect_size))

func set_GOL(node: GameOfLife):
	if not GOL:
		yield(self, "ready")
	if GOL:
		remove_child(GOL)
		GOL.queue_free()
	GOL = node
	add_child(GOL)
	_center_camera()
	$ZoomCamera.connect("zoom_changed", GOL, "set_zoom")

func _on_GOLPresetsOptionButton_GOL_changed(node):
	self.GOL = node

func _on_CenterCameraButton_pressed():
	_center_camera()
