extends PanelContainer

signal rules_changed(rules)

export var zone := 0
export var rules := {
	Global.Rules.survival: [false, false, true, true,
				false, false, false, false, false],
	Global.Rules.birth: [false, false, false, true,
			 false, false, false, false, false],
}

func _ready():
	_create_checkboxes($HBoxContainer/Survival, Global.Rules.survival, rules[Global.Rules.survival])
	_create_checkboxes($HBoxContainer/Birth, Global.Rules.birth, rules[Global.Rules.birth])
	emit_signal("rules_changed", self.zone, rules)

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
