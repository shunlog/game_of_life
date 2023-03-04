class_name Grid extends Node2D

var pixel_size = 16
var COLOR_ON : Color = Color(1, 1, 1)
var COLOR_OFF : Color = Color(0.1, 0.1, 0.1)
var COLOR_GRID : Color = Color(0, 0, 0) 
var MARGIN := 1
var m : Array = [[]]

func _ready():
	pass

func _draw_cell(p:Vector2, c:Color = COLOR_ON):
	draw_rect(Rect2(p.x*pixel_size + MARGIN, p.y*pixel_size + MARGIN,
				 pixel_size - MARGIN, pixel_size - MARGIN), c)

func _draw():
	var W = m.size()
	var H = m[0].size()
	draw_rect(Rect2(0, 0, W*pixel_size, H*pixel_size), COLOR_GRID)
	for x in range(W):
		for y in range(H):
			_draw_cell(Vector2(x, y), COLOR_ON if m[x][y] else COLOR_OFF)

func world_to_map(p:Vector2):
	return Vector2(floor(p.x / pixel_size), floor(p.y / pixel_size))
