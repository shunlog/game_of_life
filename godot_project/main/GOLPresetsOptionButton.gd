extends OptionButton

signal GOL_changed(node)

onready var GOL_scenes = Global.get_files_in_dir("res://GOL_presets/", "tscn")
var GOL :GameOfLife = null setget set_GOL

func _ready():
	populate_GOL_options_menu()
	self.GOL = load(GOL_scenes[0]).instance()

func populate_GOL_options_menu():
	var idx := 0
	for s in GOL_scenes:
		var n = s.split('/')[-1].split('.')[0]
		add_item(n, idx)
		idx += 1

func _on_GOLPresetsOptionButton_item_selected(index):
	self.GOL = load(GOL_scenes[index]).instance()

func set_GOL(v):
	GOL = v
	emit_signal("GOL_changed", GOL)
