extends Button

var GOL : GameOfLife = null

func _on_GOLController_GOL_changed(node):
	GOL = node

func _on_BitmapFileDialog_file_selected(path):
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	GOL.bitmap = tex
