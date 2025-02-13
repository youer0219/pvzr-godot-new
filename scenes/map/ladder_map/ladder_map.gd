class_name LadderMap
extends TileMapLayer

func _ready() -> void:
	update_internals()  ## 强制更新。确保在初始的梯子节点ready之后调用ready函数。
	_set_ladders()

func _set_ladders():
	var used_cells := get_used_cells()
	
	for ladder:Ladder in get_children():
		var curr_cell := local_to_map(ladder.position)
		var up_cell := curr_cell + Vector2i.UP
		var down_cell := curr_cell + Vector2i.DOWN
		
		ladder.has_up = used_cells.has(up_cell)
		ladder.has_down = used_cells.has(down_cell)

## TODO: 是否存在更加优雅的对新增和删除的节点的处理方法
# 指定 cell 生成ladder
func create_ladder_by_cell(cell:Vector2i):
	set_cell(cell,0,Vector2i.ZERO,1)
	call_deferred("_set_ladders")

# 指定 cell 删除ladder
func delete_ladder_by_cell(cell:Vector2i):
	erase_cell(cell)
	call_deferred("_set_ladders")
