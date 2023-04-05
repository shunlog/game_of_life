extends PopupDialog

func _ready():
	yield(get_tree().root, "ready")
	show()
	
func show():
	popup_centered(get_viewport_rect().size / 1.5)

func _on_ShowHelpButton_pressed():
	show()
