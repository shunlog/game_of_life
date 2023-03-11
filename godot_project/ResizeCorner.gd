extends Control


func _ready():
	pass

func _has_point(point:Vector2):
	return Rect2(rect_position, rect_position+rect_size).has_point(point)
