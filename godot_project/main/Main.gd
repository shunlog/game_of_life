extends Node2D

onready var GOL_scenes = Global.get_files_in_dir("res://GOL_presets/", "tscn")
var GOL :GameOfLife = null

func _ready():
	set_GOL_scene(0)
	populate_GOL_options_menu()
	
func _center_camera():
	$ZoomCamera.center_on_rect(Rect2(GOL.rect_position, GOL.rect_size))

func populate_GOL_options_menu():
	var idx := 0
	for s in GOL_scenes:
		var n = s.split('/')[-1].split('.')[0]
		$HUD/Control/VBoxContainer/MarginContainer2/Panel/ScrollContainer/VBoxContainer/OptionButton.add_item(n, idx)
		idx += 1

func set_GOL_scene(idx: int):
	if GOL:
		remove_child(GOL)
		GOL.queue_free()
	GOL = load(GOL_scenes[idx]).instance()
	add_child(GOL)
	$HUD/Control/VBoxContainer/MarginContainer/GOLControl.GOL = GOL
	_center_camera()


func _on_OptionButton_item_selected(index):
	set_GOL_scene(index)

func _on_ShowHelpButton_pressed():
	$HUD/Control/HelpPopupDialog.show()

func _on_CenterCameraButton2_pressed():
	_center_camera()

func _on_MovableCamera_zoom_changed(v):
	GOL.set_zoom(v)
