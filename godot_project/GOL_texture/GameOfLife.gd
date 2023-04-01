class_name GameOfLife extends Control

# We've turned off the viewport rendering in the
# Godot editor to improve battery life & development time

# We'll give input to the first renderer
# Then the CA (Cellular Automata) will ping-pong
# back and forth between the two viewports
onready var Renderer = $Viewport/Renderer
onready var Renderer2 = $Viewport2/Renderer
onready var back :Viewport = $Viewport
onready var front :Viewport = $Viewport2

export var paused := false setget set_paused
export var fps := 60
export var grid_visible := true setget set_grid_visible
export var glow := true setget set_glow
export var pen_size := 1 setget set_pen_size
export var pen_type := 1 setget set_pen_type
export var pen_randomness := .5 setget set_pen_randomness
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
					  {true: Color.green, false: Color.darkgreen},
					Color.red]
export var infectivity := .5 setget set_infectivity
export var bitmap : Texture setget set_bitmap
export var conf : Texture

# some parameters need to be set after a few updates of the shader,
# so we schedule them in this array of dicts (see _on_TextureRect_draw) 
var _scheduled_params := []
var _t := 0.0
var _steps := 0
var _draw := true

func _ready():
	if bitmap:
		_set_shaders_param("bitmap", bitmap)
		set_rect_size(bitmap)
	else:
		set_rect_size(conf)
	_update_rule_params()
	_update_color_params()
	_set_shaders_param("paused", paused)
	_set_shaders_param("pen_size", pen_size)
	_set_shaders_param("pen_type", pen_type)
	_set_shaders_param("pen_randomness", pen_randomness)
	_set_shaders_param("rand_fill_treshold", rand_fill_treshold)
	_set_shaders_param("infectivity", infectivity)
	_setup_conf()

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

func set_bitmap(v):
	bitmap = v
	_set_shaders_param("bitmap", bitmap)
	set_rect_size(bitmap)

func _setup_conf():
	Renderer.texture = conf
	front.set_update_mode(Viewport.UPDATE_ONCE)
	yield(VisualServer, "frame_post_draw")
	Renderer.texture = $Viewport2.get_texture()

	
func step():
	var pos = get_local_mouse_position()
	pos = Vector2(round(pos.x-.5)+.5, round(pos.y-.5)+.5)
	_set_shaders_param("mouse_position", pos)
	front.set_update_mode(Viewport.UPDATE_ONCE)
	_swap()

func set_rect_size(tex: Texture):
	yield(self, "ready")
	$TextureRect.rect_size = tex.get_size()
	back.size = tex.get_size() 
	front.size = tex.get_size()
	rect_size = tex.get_size()
	$Grid.update()

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
	_set_shaders_param("rand_fill_treshold", rand_fill_treshold)
	_scheduled_params.append({"frames": 2, "param": "random", "value": false})

func clear():
	_set_shaders_param("clear", true)
	_scheduled_params.append({"frames": 2, "param": "clear", "value": false})

func set_rule(zone, pressed, rule, id):
	self.rules[zone][rule][id] = pressed
	_update_rule_params()

func set_pen_size(v):
	pen_size = v
	_set_shaders_param("pen_size", v)

func set_pen_type(v):
	pen_type = v
	_set_shaders_param("pen_type", v)
	
func set_pen_randomness(v):
	pen_randomness = v
	_set_shaders_param("pen_randomness", v)

func _update_rule_params():
	_set_shaders_param("rule0s", _arr2bin(rules[0][Global.Rules.survival]))
	_set_shaders_param("rule0b", _arr2bin(rules[0][Global.Rules.birth]))
	_set_shaders_param("rule1s", _arr2bin(rules[1][Global.Rules.survival]))
	_set_shaders_param("rule1b", _arr2bin(rules[1][Global.Rules.birth]))

func set_color(zone, state, color):
	if state == null:
		colors[zone] = color
	else:
		colors[zone][state] = color
	_update_color_params()

func set_infectivity(v):
	infectivity = v
	_set_shaders_param("isp", infectivity)

func set_zoom(v: Vector2):
	$Grid.zoom = v.x

func _update_color_params():
	_set_shaders_param("color0a", colors[0][true])
	_set_shaders_param("color0d", colors[0][false])
	_set_shaders_param("color1a", colors[1][true])
	_set_shaders_param("color1d", colors[1][false])
	_set_shaders_param("color2", colors[2])

func _swap():
	var tmp = back
	back = front
	front = tmp
	$TextureRect.texture = front.get_texture()

func _set_shaders_param(p, v):
	if Renderer:
		Renderer.material.set_shader_param(p, v)
	if Renderer2:
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
	_draw = true
	for d in _scheduled_params:
		d["frames"] -= 1
		if d["frames"] == 0:
			_set_shaders_param(d["param"], d["value"])
			_scheduled_params.erase(d)  # i hope this is safe

func set_grid_visible(v):
	grid_visible = v
	$Grid.visible = v

func set_glow(v):
	glow = v
	$WorldEnvironment.environment.glow_enabled = v
