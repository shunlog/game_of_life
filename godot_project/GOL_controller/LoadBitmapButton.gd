extends Button


func _ready():
	pass


func _on_LoadBitmapButton_pressed():
	$BitmapFileDialog.popup_centered(get_viewport_rect().size / 2)
