extends PanelContainer

signal rules_changed(rules)

var rules := {Global.Rules.survival: [],
			  Global.Rules.birth: []}

func _create_checkboxes(node, rule, values):
	for i in range(len(values)):
		var cb = CheckBox.new()
		cb.text = str(i)
		node.add_child(cb)
		cb.pressed = values[i]
		cb.connect("toggled", self, "_on_cb_toggled", [rule, i])

func _ready():
	var arr8 := []
	arr8.resize(9)
	arr8.fill(false)
	rules[Global.Rules.survival] = arr8.duplicate()
	rules[Global.Rules.birth] = arr8.duplicate()
	# set defaults
	rules[Global.Rules.survival][2] = true
	rules[Global.Rules.survival][3] = true
	rules[Global.Rules.birth][3] = true
	
	_create_checkboxes($HBoxContainer/Survival, Global.Rules.survival, rules[Global.Rules.survival])
	_create_checkboxes($HBoxContainer/Birth, Global.Rules.birth, rules[Global.Rules.birth])


func _on_cb_toggled(pressed, rule, id):
	rules[rule][id] = pressed
	emit_signal("rules_changed", rules)
