extends MenuButton

signal rules_RLE_changed(rules_RLE)

var rules_RLE :=[
	["Replicator", "B1357/S1357"],
	["Seeds", "B2/S"],
	["Bouncer", "B25/S4"],
	["Life without Death", "B3/S012345678"],
	["Standard Life", "B3/S23"],
	["34 Life", "B34/S34"],
	["Diamoeba", "B35678/S5678"],
	["2x2", "B36/S125"],
	["HighLife", "B36/S23"],
	["Day & Night", "B3678/S34678"],
	["Morley", "B368/S245"],
	["Anneal", "B4678/S35678"],
	["Creeping Ivy", "B3/S2345"],
]

func _ready():
	for i in range(len(rules_RLE)):
		var label = rules_RLE[i][0]
		get_popup().add_item(label, i)
	get_popup().connect("id_pressed", self, "_popup_menu_id_pressed")

func _popup_menu_id_pressed(id):
	var d = _RLE_to_dict(rules_RLE[id][1])
	emit_signal("rules_RLE_changed", d)

func _RLE_to_dict(r: String):
	var a = []
	for i in range(9):
		a.append(false)
	var d = {Global.Rules.survival: a.duplicate(), Global.Rules.birth: a.duplicate()}
	for i in  r.split('/')[0].substr(1):
		d[Global.Rules.birth][int(i)] = true
	for i in r.split('/')[1].substr(1):
		d[Global.Rules.survival][int(i)] = true
	return d
	
