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

export var paused := false
export var fps := 60
export var rand_fill_treshold := .5
export var rules := [{Global.Rules.survival: [false, false, true, true,
						  false, false, false, false, false],
			  Global.Rules.birth: [false, false, false, true,
					   false, false, false, false, false]},
			 {Global.Rules.survival: [false, false, true, true,
						  false, false, false, false, false],
			  Global.Rules.birth: [false, false, false, true,
					   false, false, false, false, false]}]
export var colors := [{true: Color.aqua, false: Color.darkblue},
					  {true: Color.green, false: Color.darkgreen}]

# some parameters need to be set after a few updates of the shader,
# so we schedule them in this array of dicts (see _on_TextureRect_draw) 
var _scheduled_params := []
var _t := 0.0

func _ready():
	$Viewport.size = rect_size
	$Viewport2.size = rect_size
	_set_shaders_param("bitmap", $Bitmap.texture)
	_update_rule_params()
	_update_color_params()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		set_mouse_pressed(event.pressed)

func _process(delta):
	if paused:
		step()
	else:
		_t += delta
		var frame_t = (1.0 / fps)
		while _t - frame_t > 0:
			_t -= frame_t
			step()

func step():
	var pos = get_local_mouse_position()
	_set_shaders_param("mouse_position", pos)
	front.set_update_mode(Viewport.UPDATE_ONCE)
	_swap()

func unpause_one_step():
	_set_shaders_param("paused", false)
	_scheduled_params.append({"frames": 2, "param": "paused", "value": true})

func set_paused(v):
	paused = v
	_set_shaders_param("paused", v)

func set_mouse_pressed(pressed=true):
	_set_shaders_param("mouse_pressed", pressed)

func random_fill():
	_set_shaders_param("random", true)
	_set_shaders_param("random_fill", rand_fill_treshold)
	_scheduled_params.append({"frames": 2, "param": "random", "value": false})

func clear():
	_set_shaders_param("clear", true)
	_scheduled_params.append({"frames": 2, "param": "clear", "value": false})

func set_rule(zone, pressed, rule, id):
	self.rules[zone][rule][id] = pressed
	_update_rule_params()

func _update_rule_params():
	_set_shaders_param("rule0s", _arr2bin(rules[0][Global.Rules.survival]))
	_set_shaders_param("rule0b", _arr2bin(rules[0][Global.Rules.birth]))
	_set_shaders_param("rule1s", _arr2bin(rules[1][Global.Rules.survival]))
	_set_shaders_param("rule1b", _arr2bin(rules[1][Global.Rules.birth]))

func set_color(zone, state, color):
	colors[zone][state] = color
	_update_color_params()

func _update_color_params():
	_set_shaders_param("color0a", colors[0][true])
	_set_shaders_param("color0d", colors[0][false])
	_set_shaders_param("color1a", colors[1][true])
	_set_shaders_param("color1d", colors[1][false])

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
	for d in _scheduled_params:
		d["frames"] -= 1
		if d["frames"] == 0:
			_set_shaders_param(d["param"], d["value"])
			_scheduled_params.erase(d)  # i hope this is safe
