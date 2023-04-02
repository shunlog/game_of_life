extends PanelContainer

export var zone := 0

var rules = {Global.Rules.survival: [], Global.Rules.birth: []} setget set_rules
var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	set_rules(GOL.rules[zone])
	set_color(GOL.colors[zone])
	
func _ready():
	_create_checkboxes($VBoxContainer/HBoxContainer/Survival, Global.Rules.survival)
	_create_checkboxes($VBoxContainer/HBoxContainer/Birth, Global.Rules.birth)

func _create_checkboxes(node, rule):
	for i in range(9):
		var cb = CheckBox.new()
		cb.text = str(i)
		node.add_child(cb)
		cb.connect("toggled", self, "_on_cb_toggled", [rule, i])
		rules[rule].append(cb)

func set_rules(d):
	for r in [Global.Rules.survival, Global.Rules.birth]:
		for i in range(9):
			rules[r][i].pressed = d[r][i]

func set_color(colors):
	$VBoxContainer/HBoxContainer2/AliveColorPickerButton.color = colors[true]
	$VBoxContainer/HBoxContainer3/DeadColorPickerButton.color = colors[false]

func _on_cb_toggled(pressed, rule, id):
	GOL.set_rule(zone, pressed, rule, id)

func _on_AliveColorPickerButton_color_changed(color):
	GOL.set_color(zone, true, color)

func _on_DeadColorPickerButton_color_changed(color):
	GOL.set_color(zone, false, color)

func _on_PresetRulesMenuButton_rules_RLE_changed(rules_RLE):
	self.rules = rules_RLE
