extends PanelContainer

signal rule_changed(pressed, rule, id)
signal color_changed(state, color)

export var zone := 0

var _checkboxes = {Global.Rules.survival: [], Global.Rules.birth: []}

func _ready():
	_create_checkboxes($VBoxContainer/HBoxContainer/Survival, Global.Rules.survival)
	_create_checkboxes($VBoxContainer/HBoxContainer/Birth, Global.Rules.birth)

func _create_checkboxes(node, rule):
	for i in range(9):
		var cb = CheckBox.new()
		cb.text = str(i)
		node.add_child(cb)
		cb.connect("toggled", self, "_on_cb_toggled", [rule, i])
		_checkboxes[rule].append(cb)

func set_checkboxes(rules):
	for r in [Global.Rules.survival, Global.Rules.birth]:
		for i in range(9):
			_checkboxes[r][i].pressed = rules[r][i]

func set_color(colors):
	$VBoxContainer/HBoxContainer2/AliveColorPickerButton.color = colors[true]
	$VBoxContainer/HBoxContainer3/DeadColorPickerButton.color = colors[false]

func _on_cb_toggled(pressed, rule, id):
	emit_signal("rule_changed", self.zone, pressed, rule, id)

func _on_AliveColorPickerButton_color_changed(color):
	emit_signal("color_changed", true, color)

func _on_DeadColorPickerButton_color_changed(color):
	emit_signal("color_changed", false, color)
