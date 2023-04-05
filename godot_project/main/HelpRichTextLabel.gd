extends RichTextLabel


func _ready():
	pass

func _on_HelpRichTextLabel_meta_clicked(meta):
	OS.shell_open(str(meta))
