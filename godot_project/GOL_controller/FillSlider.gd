extends HSlider

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node
	value = GOL.rand_fill_treshold

func _on_FillSlider_value_changed(value):
	GOL.rand_fill_treshold = value
