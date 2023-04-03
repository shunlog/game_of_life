extends Spatial

func _ready():
	$CanvasLayer/HUD.GOL = $Viewport3/GameOfLife
	$Viewport3.size = $Viewport3/GameOfLife.rect_size
