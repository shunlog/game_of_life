extends Control

# We've turned off the viewport rendering in the
# Godot editor to improve battery life & development time

# We'll give input to the first renderer
# Then the CA (Cellular Automata) will ping-pong
# back and forth between the two viewports
onready var Renderer = $Viewport/Renderer

var t := 0.0
var step := 0.01

func _ready():
	$Viewport.size = rect_size
	$Viewport2.size = rect_size

func step():
	$Viewport.set_update_mode(Viewport.UPDATE_ONCE)
	$Viewport2.set_update_mode(Viewport.UPDATE_ONCE)
	# reset params
#	Renderer.material.set_shader_param("mouse_pressed", false)
#	Renderer.material.set_shader_param("random", false)

func draw_mouse(pressed=true):
	Renderer.material.set_shader_param("mouse_pressed", pressed)
	var pos = get_local_mouse_position()
	print(pos)

	Renderer.material.set_shader_param("mouse_position", pos)

func random(active=true):
	Renderer.material.set_shader_param("random", active)
