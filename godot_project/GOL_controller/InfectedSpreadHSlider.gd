extends HSlider

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	value = GOL.infectivity

func _on_InfectedSpreadHSlider_value_changed(value):
	GOL.infectivity = value
