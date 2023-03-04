extends Node2D

onready var g = Automaton.new()
var t = 0.0
var _draw : bool = false
var _speed : float = 0.1
var _paused : bool = true
signal pause_state_changed(paused)
# useful methods for TileMap:
# get_cell, set_cell, get_used_cells, get_used_rect

func _ready():
	add_child(g)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.is_pressed():
				var v = $TileMap.world_to_map(get_global_mouse_position())
				g.toggle_cell(v)
				g.set_tilemap($TileMap)
				_draw = true
			else:
				_draw = false
	elif event.is_action_pressed("step"):
		g.step()
		g.set_tilemap($TileMap)
	elif event.is_action_pressed("pause"):
		_pause_toggle()
	elif event is InputEventMouseMotion and _draw:
		g.set_cell($TileMap.world_to_map(get_global_mouse_position()), true)
		g.set_tilemap($TileMap)

func _process(delta):
	if not _paused:
		g.set_tilemap($TileMap)
		t += delta
		while t - _speed > 0:
			t -= _speed
			g.step()

func _on_HSlider_value_changed(value):
	_speed = value

func _pause_toggle():
	_paused = !_paused
	emit_signal("pause_state_changed", _paused)

func _on_Button_button_down():
	g.fill_random()
	g.set_tilemap($TileMap)
