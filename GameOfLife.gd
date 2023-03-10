extends Control

# We've turned off the viewport rendering in the
# Godot editor to improve battery life & development time

# We'll give input to the first renderer
# Then the CA (Cellular Automata) will ping-pong
# back and forth between the two viewports
onready var Renderer = $"/root/GameOfLife/Viewport/Renderer"

var t := 0.0
var step := 0.01

func _ready():
	$Viewport.size = rect_size
	$Viewport2.size = rect_size

func step():
	$Viewport.set_update_mode(Viewport.UPDATE_ONCE)
	$Viewport2.set_update_mode(Viewport.UPDATE_ONCE)

func draw_mouse(event):
	Renderer.material.set_shader_param("mouse_pressed", true)
	var pos = get_local_mouse_position()

	Renderer.material.set_shader_param("mouse_position", pos)

func random(v=true):
	Renderer.material.set_shader_param("random", v)
