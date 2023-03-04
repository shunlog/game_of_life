extends Node2D

onready var grid = Grid.new()
onready var aut = Automaton.new(grid)
var t = 0.0
var _draw : bool = false
var _speed : float = 0.1
var _paused : bool = true

signal pause_state_changed(paused)

func _ready():
	add_child(aut)
	add_child(grid)

func _input(event):
	if event is InputEventMouseMotion and _draw:
		aut.set_cell(grid.world_to_map(get_global_mouse_position()), true)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.is_pressed():
				var v = grid.world_to_map(get_global_mouse_position())
				aut.toggle_cell(v)
				_draw = true
			else:
				_draw = false
	elif event.is_action_pressed("step"):
		_step()
	elif event.is_action_pressed("pause"):
		_pause_toggle()

func _step():
	aut.step()

func _process(delta):
	if not _paused:
		t += delta
		while t - _speed > 0:
			t -= _speed
			aut.step()

func _on_HSlider_value_changed(value):
	_speed = value

func _pause_toggle():
	_paused = !_paused
	emit_signal("pause_state_changed", _paused)

func _on_Random_button_down():
	aut.fill_random()

func _on_ButtonClear_button_down():
	aut.clear()

func _on_CheckButtonSimulation_toggled(_button_pressed):
	_pause_toggle()

func _on_ButtonStep_button_down():
	_step()
