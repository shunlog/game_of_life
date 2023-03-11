extends Node2D

var t = 0.0
var _draw : bool = false
var _smltn_fps : float = 0.1
var _paused : bool = true
var _rand_fill : float

signal pause_state_changed(paused)

func _ready():
	for r in get_tree().get_nodes_in_group("rules"):
		r.connect("rule_updated", self, "_on_rule_updated")
#		r.set_checked(aut.rules[r.rule])

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		$GameOfLife.set_mouse_pressed(event.pressed)
	elif event.is_action_pressed("step"):
		_step()
	elif event.is_action_pressed("pause"):
		_pause(!_paused)

func _step():
	$GameOfLife.step()

func _process(delta):
	if _paused:
		_step()
	else:
		t += delta
		var frame_t = (1 / _smltn_fps)
		while t - frame_t > 0:
			t -= frame_t
			_step()

func _on_HSlider_value_changed(value):
	_smltn_fps = value

func _pause(paused):
	_paused = paused
	emit_signal("pause_state_changed", paused)
	$GameOfLife.set_paused(paused)

func _on_Random_button_down():
	$GameOfLife.random(_rand_fill)

func _on_ButtonClear_button_down():
	pass
#	aut.clear()

func _on_ButtonStep_button_down():
	_step()

func _on_rule_updated(rule, ls):
	pass
#	aut.rules[rule] = ls

func _on_SpinBoxRandFill_value_changed(value):
	_rand_fill = value

func _on_CheckButtonSimulation_toggled(button_pressed):
	_pause(!button_pressed)
