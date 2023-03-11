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
var step := 0.01
var rand_steps := 0

func _ready():
	$Viewport.size = rect_size
	$Viewport2.size = rect_size

func _swap():
	var tmp = back
	back = front
	front = tmp

func _set_shaders_param(p, v):
	Renderer.material.set_shader_param(p, v)
	Renderer2.material.set_shader_param(p, v)

func step():
	var pos = get_local_mouse_position()
	_set_shaders_param("mouse_position", pos)
	
	front.set_update_mode(Viewport.UPDATE_ONCE)
	$TextureRect.texture = front.get_texture()
	_swap()

func set_paused(paused):
	_set_shaders_param("paused", paused)

func set_mouse_pressed(pressed=true):
	_set_shaders_param("mouse_pressed", pressed)

func random(fill):
	_set_shaders_param("random", true)
	_set_shaders_param("random_fill", fill)
	rand_steps = 0

func _on_TextureRect_draw():
	rand_steps += 1
	if rand_steps == 2:
		_set_shaders_param("random", false)
