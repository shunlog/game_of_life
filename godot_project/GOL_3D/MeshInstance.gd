extends MeshInstance

var _moveCamera: bool = false;

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			_moveCamera = event.is_pressed()
	elif event is InputEventMouseMotion && _moveCamera:
		rotate_x(event.relative.y * .01)
		rotate_y(event.relative.x * .01)
