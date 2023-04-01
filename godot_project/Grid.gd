extends Node2D

var zoom := 1.0 setget _set_zoom

func _ready():
	update()

func _set_zoom(v):
	zoom = v
	update()

func _draw():
	var sz = get_parent().rect_size
	if zoom  < .2:
		for x in range(sz.y):
			draw_line(Vector2(0, x), Vector2(sz.x, x), Color("#555"), 1.0)
		for y in range(sz.x):
			draw_line(Vector2(y, 0), Vector2(y, sz.y), Color("#555"), 1.0)
	if zoom  < .5:
		for x in range(0, sz.y, 20):
			draw_line(Vector2(0, x), Vector2(sz.x, x), Color("#eee"), 1.0)
		for y in range(0, sz.x, 20):
			draw_line(Vector2(y, 0), Vector2(y, sz.y), Color("#eee"), 1.0)
