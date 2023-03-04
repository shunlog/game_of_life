class_name Grid extends Node2D

var pixel_size = 16
var COLOR_ON : Color = Color(255, 0, 0)
var COLOR_OFF : Color = Color(0, 0, 0)
var aut

func _init(a :Automaton):
	aut = a

func _ready():
	aut.connect("matrix_updated", self, "_on_automaton_updated")
	pass

func _draw():
	draw_rect(Rect2(0, 0, aut.GRID_W*pixel_size, aut.GRID_H*pixel_size), COLOR_OFF)
	for x in range(aut.GRID_W):
		for y in range(aut.GRID_H):
			if aut.m[x][y]:
				draw_rect(Rect2(x*pixel_size, y*pixel_size,
				 pixel_size, pixel_size), COLOR_ON)

func _on_automaton_updated():
	update()

func world_to_map(p:Vector2):
	return Vector2(floor(p.x / pixel_size), floor(p.y / pixel_size))
