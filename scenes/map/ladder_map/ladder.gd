class_name Ladder
extends Sprite2D

var has_up:bool:set = _set_has_up
var has_down:bool:set = _set_has_down

func _set_has_up(value:bool):
	has_up = value
	
	_set_ladder_texure()

func _set_has_down(value:bool):
	has_down = value
	
	_set_ladder_texure()

func _set_ladder_texure():
	assert(texture,"梯子纹理不存在！")
	
	if has_up and not has_down:
		# 底端：有上无下
		region_rect.position = Vector2(1,0) * Level.CELL_SIZE
	elif not has_up and has_down:
		# 顶端：无上有下
		region_rect.position = Vector2(0,0) * Level.CELL_SIZE
	elif has_up and has_down:
		# 中间：有上有下
		region_rect.position = Vector2(3,0) * Level.CELL_SIZE
	elif not has_up and not has_down:
		# 孤立：无上无下
		region_rect.position = Vector2(2,0) * Level.CELL_SIZE
