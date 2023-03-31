extends Node

enum Rules {survival, birth}


func get_files_in_dir(path: String, ext: String) -> Array:
	var dir = Directory.new()
	if dir.open(path) != OK:
		print("An error occurred when trying to access the path.")
		return []
	
	var ls := []
	dir.list_dir_begin()
	while true:
		var fn = dir.get_next()
		if fn == "":
			break
		if !dir.current_is_dir() and fn.split(".")[-1] == ext:
			ls.append(path + fn)
	return ls
