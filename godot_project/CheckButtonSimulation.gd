extends CheckButton


func _ready():
	pass

func _on_Root_pause_state_changed(paused):
	set_pressed_no_signal(!paused)
