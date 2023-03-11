extends Camera2D


var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var zoom_mult = 1.1

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				_previousPosition = event.position;
				_moveCamera = true;
			else:
				_moveCamera = false;
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_at_point(zoom_mult, event.position)
		elif (event.button_index == BUTTON_WHEEL_UP):
			if zoom[0] < .2:
				return
			zoom_at_point(1/zoom_mult, event.position)
			

	elif event is InputEventMouseMotion && _moveCamera:
		position += zoom * (_previousPosition - event.position)
		_previousPosition = event.position;
		
func zoom_at_point(zoom_change, point):
	var c0 = global_position
	var v0 = get_viewport().size
	var z0 = zoom
	var z1 = z0 * zoom_change
	var c1 = c0 + (-0.5 * v0 + point) * (z0 - z1)
	zoom = z1
	global_position = c1
