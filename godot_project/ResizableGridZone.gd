extends Control

var _previousPosition: Vector2 = Vector2(0, 0);
var _move := false;

func _ready():
	pass 

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				_previousPosition = event.position;
				_move = true;
			else:
				_move = false;
				
	if event is InputEventMouseMotion && _move:
		print(rect_position)
		rect_position += - _previousPosition + event.position
		_previousPosition = event.position;
