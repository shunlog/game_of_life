extends Node2D

func _ready():
	$HUD.GOL = $GameOfLife

func _on_GameOfLife_mouse_entered():
	$HUD.GOL = $GameOfLife

func _on_GameOfLife2_mouse_entered():
	$HUD.GOL = $GameOfLife2
