project=godot_project

.PHONY: exports/html itch status_itch

exports/html:
	godot --path $(project) --export HTML5

exports/html.zip: exports/html
	zip -r exports/html.zip exports/html

itch: exports/html.zip
	butler push exports/html.zip shunlog/gol:html
