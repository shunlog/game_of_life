extends PanelContainer

signal rules_changed

var rules := {Global.Rules.survival: [],
			  Global.Rules.birth: []}

func _create_checkboxes(node, rule):
	for i in range(8):
		var cb = CheckBox.new()
		cb.text = str(i)
		node.add_child(cb)
		cb.connect("toggled", self, "_on_cb_toggled", [rule, i])

func _ready():
	var arr8 := []
	arr8.resize(8)
	arr8.fill(false)
	rules[Global.Rules.survival] = arr8.duplicate()
	rules[Global.Rules.birth] = arr8.duplicate()
	
	_create_checkboxes($HBoxContainer/Survival, Global.Rules.survival)
	_create_checkboxes($HBoxContainer/Birth, Global.Rules.birth)

func _on_cb_toggled(pressed, rule, id):
	rules[rule][id] = pressed
	emit_signal("rules_changed", rules)
