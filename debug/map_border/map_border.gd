@tool
extends Node2D

const MAX_HIGHT_CELLS := 24
const MAX_LENTH_CELLS := 72

@export var enable:bool = false:set = _set_enable

func _draw() -> void:
	if not enable:
		return
	
	var rect:Rect2 = Rect2(Vector2.ZERO, MapData.MAP_SIZE * MapData.MAP_CELL_SIZE)
	draw_rect(rect,Color.BROWN,false,3)

func _set_enable(value:bool):
	enable = value
	
	queue_redraw()
