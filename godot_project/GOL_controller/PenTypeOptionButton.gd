extends OptionButton

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	self.selected = get_item_index(GOL.pen_type)

func _on_PenTypeOptionButton_item_selected(index):
	# the setter is triggered only via code
	self.selected = index

func _input(event):
	if event.is_action_pressed("pen_type_alive"):
		self.selected = 0
	elif event.is_action_pressed("pen_type_dead"):
		self.selected = 1
	elif event.is_action_pressed("pen_type_infected"):
		self.selected = 2

func _set(property, value):
	# add setter for inherited var
	if property == "selected":
		_set_selected(value)
	
func _set_selected(v):
	selected = v
	GOL.pen_type = get_item_id(v)

