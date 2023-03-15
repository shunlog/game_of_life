extends Node2D

var _fps : float
var _paused : bool
var _rand_fill : float

func _step_once():
	$GameOfLife.unpause_one_step()

func _set_fps(v):
	_fps = v
	$GameOfLife.fps = v

func _pause(paused):
	_paused = paused
	$GameOfLife.set_paused(paused)

func _on_HSlider_value_changed(value):
	_set_fps(value)

func _on_Random_button_down():
	$GameOfLife.random_fill(_rand_fill)

func _on_ButtonClear_button_down():
	$GameOfLife.clear()

func _on_SpinBoxRandFill_value_changed(value):
	_rand_fill = value

func _on_CheckButtonSimulation_toggled(button_pressed):
	_pause(!button_pressed)

func _on_Zone_rules_changed(zone, rules):
	$GameOfLife.set_rules(zone, rules)

func _on_ButtonStep_pressed():
	_step_once()
