extends Camera2D

signal zoom_changed(v)

export var zoom_mult := 1.1
export var max_zoom := .2
var min_zoom := 100.0
var _moveCamera: bool = false;

func _set(property, value):
	if property == "zoom":
		zoom = value
		emit_signal("zoom_changed", zoom)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom_at_point(zoom_mult, event.position)
		elif (event.button_index == BUTTON_WHEEL_UP):
			zoom_at_point(1/zoom_mult, event.position)
		elif event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				_moveCamera = true;
			else:
				_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		position += zoom * -event.relative
		
func zoom_at_point(zoom_change, point):
	var c0 = global_position
	var v0 = get_viewport().size
	var z0 = zoom
	var z1 = z0 * zoom_change
	var c1 = c0 + (-0.5 * v0 + point) * (z0 - z1)
	if z1[0] < max_zoom or z1[0] > min_zoom:
		return
	self.zoom = z1
	global_position = c1

func center_on_rect(r:Rect2):
	position = (r.position + r.size)/2
	var scale = r.size / get_viewport_rect().size
	var z = max(scale[0], scale[1]) * 1.2
	self.zoom = Vector2(z, z)
	min_zoom = z * 1.2
