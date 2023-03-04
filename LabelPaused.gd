extends Label


func _ready():
	pass


func _on_Root_pause_state_changed(paused):
	text = "Stopped" if paused else "Running"
