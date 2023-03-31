extends Control

onready var GOL :GameOfLife setget set_GOL

func set_GOL(v):
	GOL = v
	$Panel/ScrollContainer/VBoxContainer/PauseHBoxContainer/CheckButtonSimulation.pressed = !GOL.paused
	$Panel/ScrollContainer/VBoxContainer/SpeedHBoxContainer/HSliderSpeed.set_value(GOL.fps)
	$Panel/ScrollContainer/VBoxContainer/FillHBoxContainer/SpinBoxRandFill.value = GOL.rand_fill_treshold
	$Panel/ScrollContainer/VBoxContainer/ZonesRulesTabContainer/Zone0.set_checkboxes(GOL.rules[0])
	$Panel/ScrollContainer/VBoxContainer/ZonesRulesTabContainer/Zone1.set_checkboxes(GOL.rules[1])
	$Panel/ScrollContainer/VBoxContainer/ZonesRulesTabContainer/Zone0.set_color(GOL.colors[0])
	$Panel/ScrollContainer/VBoxContainer/ZonesRulesTabContainer/Zone1.set_color(GOL.colors[1])
	$Panel/ScrollContainer/VBoxContainer/ZonesRulesTabContainer/Infection/VBoxContainer/HBoxContainer/ColorPickerButton.color = GOL.colors[2]
	$Panel/ScrollContainer/VBoxContainer/ZonesRulesTabContainer/Infection/VBoxContainer/HBoxContainer2/HSlider.value = GOL.infectivity
	$Panel/ScrollContainer/VBoxContainer/GridBoxContainer/HSlider.value = GOL.pen_size
	$Panel/ScrollContainer/VBoxContainer/PenTypeOptionButton.selected = $Panel/ScrollContainer/VBoxContainer/PenTypeOptionButton.get_item_index(GOL.pen_type)
	$Panel/ScrollContainer/VBoxContainer/GridBoxContainer/HSlider2.value = GOL.pen_randomness

func _on_ButtonClear_button_down():
	GOL.clear()

func _on_SpinBoxRandFill_value_changed(value):
	GOL.rand_fill_treshold = value

func _on_CheckButtonSimulation_toggled(button_pressed):
	GOL.set_paused(!button_pressed)

func _on_ButtonStep_pressed():
	GOL.unpause_one_step()

func _on_HSliderSpeed_value_changed(value):
	GOL.fps = value

func _on_ButtonRandom_button_down():
	GOL.random_fill()

func _on_Zone_rule_changed(zone, pressed, rule, id):
	GOL.set_rule(zone, pressed, rule, id)

func _on_Zone0_color_changed(state, color):
	GOL.set_color(0, state, color)

func _on_Zone1_color_changed(state, color):
	GOL.set_color(1, state, color)

func _on_infected_color_changed(color):
	GOL.set_color(2, null, color)

func _on_infectivity_value_changed(value):
	GOL.infectivity = value

func _on_pen_size_HSlider_value_changed(value):
	GOL.pen_size = value

func _on_PenTypeOptionButton_pen_type_changed(id):
	GOL.pen_type = id

func _on_PenRandom_value_changed(value):
	GOL.pen_randomness = value

func _on_GridCheckButtonSimulation_toggled(button_pressed):
	GOL.grid_visible = button_pressed


func _on_BitmapFileDialog_file_selected(path):
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	GOL.set_bitmap(tex)
