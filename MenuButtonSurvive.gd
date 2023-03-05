extends MenuButton
onready var pop : PopupMenu = get_popup()
signal rule_updated(rule, ls)

export(Global.Rules) var rule

func _ready():
	add_to_group("rules")
	pop.hide_on_checkable_item_selection = false
	for i in range(9):
		pop.add_check_item(str(i), i)
	pop.connect("id_pressed", self, "_on_id_pressed")

func _on_id_pressed(id):
	var idx = pop.get_item_index(id)
	pop.set_item_checked(idx, !pop.is_item_checked(idx))
	
	var ls = []
	for i in range(9):
		idx = pop.get_item_index(i)
		if pop.is_item_checked(idx):
			ls.append(i)
	emit_signal("rule_updated", rule, ls)
#	print(ls)

func set_checked(ls):
	for id in ls:
		var idx = pop.get_item_index(id)
		pop.set_item_checked(idx, true)
