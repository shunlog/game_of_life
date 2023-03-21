extends PanelContainer

signal rules_changed(rules)
signal colors_changed(colors)

export var zone := 0
export var rules := {
	Global.Rules.survival: [false, false, true, true,
				false, false, false, false, false],
	Global.Rules.birth: [false, false, false, true,
			 false, false, false, false, false],
}
export var colors := [Color.white, Color.black]


func _ready():
	_create_checkboxes($VBoxContainer/HBoxContainer/Survival, Global.Rules.survival, rules[Global.Rules.survival])
	_create_checkboxes($VBoxContainer/HBoxContainer/Birth, Global.Rules.birth, rules[Global.Rules.birth])
	emit_signal("rules_changed", self.zone, rules)
	emit_signal("colors_changed", self.zone, colors)

func _create_checkboxes(node, rule, values):
	for i in range(len(values)):
		var cb = CheckBox.new()
		cb.text = str(i)
		node.add_child(cb)
		cb.pressed = values[i]
		cb.connect("toggled", self, "_on_cb_toggled", [rule, i])

func _on_cb_toggled(pressed, rule, id):
	rules[rule][id] = pressed
	emit_signal("rules_changed", self.zone, rules)

func _on_ColorPickerButton_color_changed(_color):
	colors[0] = $VBoxContainer/HBoxContainer2/ColorPickerButton.color
	colors[1] = $VBoxContainer/HBoxContainer3/ColorPickerButton.color
	emit_signal("colors_changed", self.zone, colors)
