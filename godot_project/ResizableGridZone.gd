extends Control

var _previousPosition: Vector2
var _within_resize := false;
var _wanted_position := get_global_rect().position
var _wanted_size := rect_size
var _pressed := false;
export var grid_size := 20

func _ready():
	print(_wanted_position)
	pass 
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_pressed = event.pressed
		if event.pressed:
			_previousPosition = get_global_mouse_position()
	if event is InputEventMouseMotion and _pressed:
		var gl = get_global_mouse_position()
		drag(_previousPosition, gl)
		_previousPosition = gl

func within_rect(p:Vector2, r:Rect2):
	var rp = r.position
	var rs = r.size
	if p.x < rp.x or p.y < rp.y or p.x > rs.x or p.y > rs.y:
		return true
	return false

func drag(from:Vector2, to:Vector2):
	if _within_resize:
		_wanted_size += to - from
		rect_size = snap_position(_wanted_size)
	elif not _within_resize:
		_wanted_position += to - from
		rect_position = snap_position(_wanted_position)

func snap_position(p:Vector2):
	p.x = int(p.x - int(p.x) % grid_size)
	p.y = int(p.y - int(p.y) % grid_size)
	return p

func _on_ResizeCorner_mouse_entered():
	_within_resize = true

func _on_ResizeCorner_mouse_exited():
	_within_resize = false
