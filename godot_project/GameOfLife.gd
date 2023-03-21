extends Control

# We've turned off the viewport rendering in the
# Godot editor to improve battery life & development time

# We'll give input to the first renderer
# Then the CA (Cellular Automata) will ping-pong
# back and forth between the two viewports
onready var Renderer = $Viewport/Renderer
onready var Renderer2 = $Viewport2/Renderer
onready var back :Viewport = $Viewport
onready var front :Viewport = $Viewport2

var t := 0.0
var paused := false
var fps := 60
# some parameters need to be set after a few updates of the shader,
# so we schedule them in this array of dicts (see _on_TextureRect_draw) 
var scheduled_params := []

func _ready():
	$Viewport.size = rect_size
	$Viewport2.size = rect_size
	_set_shaders_param("bitmap", $Bitmap.texture)
	

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		set_mouse_pressed(event.pressed)

func _process(delta):
	if paused:
		step()
	else:
		t += delta
		var frame_t = (1.0 / fps)
		while t - frame_t > 0:
			t -= frame_t
			step()

func step():
	var pos = get_local_mouse_position()
	_set_shaders_param("mouse_position", pos)
	front.set_update_mode(Viewport.UPDATE_ONCE)
	_swap()

func unpause_one_step():
	_set_shaders_param("paused", false)
	scheduled_params.append({"frames": 2, "param": "paused", "value": true})

func set_paused(v):
	paused = v
	_set_shaders_param("paused", v)

func set_mouse_pressed(pressed=true):
	_set_shaders_param("mouse_pressed", pressed)

func random_fill(fill):
	_set_shaders_param("random", true)
	_set_shaders_param("random_fill", fill)
	scheduled_params.append({"frames": 2, "param": "random", "value": false})

func clear():
	_set_shaders_param("clear", true)
	scheduled_params.append({"frames": 2, "param": "clear", "value": false})

func set_rules(zone, rules):
	var s = _arr2bin(rules[Global.Rules.survival])
	var b = _arr2bin(rules[Global.Rules.birth])
	if zone == 0:
		_set_shaders_param("survival_rules", s)
		_set_shaders_param("birth_rules", b)
	elif zone == 1:
		_set_shaders_param("survival_rules2", s)
		_set_shaders_param("birth_rules2", b)

func set_colors(zone, colors):
	print(colors)
	if zone == 0:
		_set_shaders_param("color_alive0", colors[0])
		_set_shaders_param("color_dead0", colors[1])
	elif zone == 1:
		_set_shaders_param("color_alive1", colors[0])
		_set_shaders_param("color_dead1", colors[1])

func _swap():
	var tmp = back
	back = front
	front = tmp
	$TextureRect.texture = front.get_texture()

func _set_shaders_param(p, v):
	Renderer.material.set_shader_param(p, v)
	Renderer2.material.set_shader_param(p, v)

func _arr2bin(a:Array):
	# convert an array of booleans "a" with into an integer "n" such that
	# n[i (starting from the right)] == 1 if a[i] else 0
	# example [false, true] -> 0b10
	var b := 0
	for i in range(len(a)-1, -1, -1):
		b = b << 1
		if a[i]:
			b += 1
	return b

func _on_TextureRect_draw():
	for d in scheduled_params:
		d["frames"] -= 1
		if d["frames"] == 0:
			_set_shaders_param(d["param"], d["value"])
			scheduled_params.erase(d)  # i hope this is safe
