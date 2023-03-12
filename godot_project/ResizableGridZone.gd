extends Control

var _previousPosition: Vector2
var _within_resize := false;
onready var _wanted_position := rect_position
onready var _wanted_size := rect_size
var _pressed := false;
export var grid_size := 20

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_pressed = event.pressed
		if event.pressed:
			_previousPosition = get_global_mouse_position()
	if event is InputEventMouseMotion and _pressed:
		var gl = get_global_mouse_position()
		drag(_previousPosition, gl)
		_previousPosition = gl

func drag(from:Vector2, to:Vector2):
	if _within_resize:
		_wanted_size += to - from
		_wanted_size = min_clamp(_wanted_size, Vector2(grid_size, grid_size))
		rect_size = snap_to_grid(_wanted_size)
	else:
		_wanted_position += to - from
		rect_position = snap_to_grid(_wanted_position)

func min_clamp(v, vmin):
	return vclamp(v, vmin, Vector2(INF, INF))

func vclamp(v, vmin, vmax):
	v.x = min(max(v.x, vmin.x), vmax.x)
	v.y = min(max(v.y, vmin.y), vmax.y)
	return v
	
func snap_to_grid(p:Vector2) -> Vector2:
	p.x = int(p.x - int(p.x) % grid_size)
	p.y = int(p.y - int(p.y) % grid_size)
	return p

func _on_ResizeCorner_mouse_entered():
	_within_resize = true

func _on_ResizeCorner_mouse_exited():
	_within_resize = false
