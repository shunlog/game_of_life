extends Node2D

export var tile_size = 50


func _draw():
	var vr = get_viewport_rect()
	var w = vr.size[0]
	var h = vr.size[1]
	draw_rect(vr, Color("#333"))
	
	for i in range(int(w / tile_size)+1):
		for j in range(int(h / tile_size)+1):
			if (i + j) % 2 == 0:
				continue
			var x = i * tile_size
			var y = j * tile_size
			draw_rect(Rect2(x, y, tile_size, tile_size), Color("#444"))
			
