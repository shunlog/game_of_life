extends Node2D

onready var GOL_scenes = get_scenes_in_dir("res://GOL_scenes/")
var GOL :GameOfLife = null

func _ready():
	set_GOL_scene(0)
	populate_GOL_options_menu()
	
func _center_camera():
	$MovableCamera.center_on_rect(Rect2(GOL.rect_position, GOL.rect_size))

func populate_GOL_options_menu():
	var idx := 0
	for s in GOL_scenes:
		var n = s.split('/')[-1].split('.')[0]
		$HUD/Control/VBoxContainer/MarginContainer2/Panel/VBoxContainer/OptionButton.add_item(n, idx)
		idx += 1

func set_GOL_scene(idx: int):
	if GOL:
		GOL.queue_free()
	GOL = load(GOL_scenes[idx]).instance()
	add_child(GOL)
	$HUD/Control/VBoxContainer/MarginContainer/GOLControl.GOL = GOL
	_center_camera()

func get_scenes_in_dir(path) -> Array:
	var dir = Directory.new()
	if dir.open(path) != OK:
		print("An error occurred when trying to access the path.")
		return []
	
	var ls := []
	dir.list_dir_begin()
	while true:
		var fn = dir.get_next()
		if fn == "":
			break
		if !dir.current_is_dir() and fn.split(".")[-1] == "tscn":
			ls.append(path + fn)
	return ls


func _on_OptionButton_item_selected(index):
	set_GOL_scene(index)

func _on_ShowHelpButton_pressed():
	$HUD/Control/HelpPopupDialog.show()

func _on_CenterCameraButton2_pressed():
	_center_camera()

func _on_MovableCamera_zoom_changed(v):
	GOL.set_zoom(v)
