extends Node2D

var zoom := 1.0 setget _set_zoom
export var grid_color := Color.gray

func _ready():
	update()

func _set_zoom(v):
	zoom = v
	update()

func _draw():
	var sz = get_parent().rect_size
	var step := 5
	var s := max(int(zoom * 100 / step) * step, 1)
	for x in range(sz.y / s + 1):
		draw_line(Vector2(0, x * s), Vector2(sz.x, x * s), grid_color, 1.0)
	for y in range(sz.x / s + 1):
		draw_line(Vector2(y * s, 0), Vector2(y * s, sz.y), grid_color, 1.0)
