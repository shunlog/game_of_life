extends Node2D

var t = 0.0
var _draw : bool = false
var _fps : float
var _paused : bool
var _rand_fill : float

signal pause_state_changed(paused)

func _ready():
	for r in get_tree().get_nodes_in_group("rules"):
		r.connect("rule_updated", self, "_on_rule_updated")
#		r.set_checked(aut.rules[r.rule])

func _input(event):
	if event.is_action_pressed("pause"):
		_pause(!_paused)

func _step():
	$GameOfLife.step()

func _set_fps(v):
	_fps = v
	$GameOfLife.fps = v

func _on_HSlider_value_changed(value):
	_set_fps(value)

func _pause(paused):
	_paused = paused
	emit_signal("pause_state_changed", paused)
	$GameOfLife.set_paused(paused)

func _on_Random_button_down():
	$GameOfLife.random(_rand_fill)

func _on_ButtonClear_button_down():
	
	$GameOfLife.clear()

func _on_ButtonStep_button_down():
	_step()

func _on_rule_updated(rule, ls):
	pass
#	aut.rules[rule] = ls

func _on_SpinBoxRandFill_value_changed(value):
	_rand_fill = value

func _on_CheckButtonSimulation_toggled(button_pressed):
	_pause(!button_pressed)
