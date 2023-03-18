extends CanvasLayer

var _fps : float
var _paused : bool
var _rand_fill : float
onready var GOL = null

func _step_once():
	GOL.unpause_one_step()

func _set_fps(v):
	_fps = v
	if GOL:
		GOL.fps = v

func _pause(paused):
	_paused = paused
	if GOL:
		GOL.set_paused(paused)

func _on_ButtonClear_button_down():
	GOL.clear()

func _on_SpinBoxRandFill_value_changed(value):
	_rand_fill = value

func _on_CheckButtonSimulation_toggled(button_pressed):
	_pause(!button_pressed)

func _on_Zone_rules_changed(zone, rules):
	if GOL:
		GOL.set_rules(zone, rules)

func _on_ButtonStep_pressed():
	_step_once()

func _on_HSliderSpeed_value_changed(value):
	_set_fps(value)

func _on_ButtonRandom_button_down():
	GOL.random_fill(_rand_fill)
