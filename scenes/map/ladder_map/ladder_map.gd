class_name LadderMap
extends TileMapLayer

func create_ladder_by_cell(cell:Vector2i):
	## TODO: 不能在有水的地方生成，所以可能需要一个检查
	set_cell(cell,1,Vector2i(2,0))
	set_cells_terrain_connect([cell],0,0)

func deleta_ladder_by_cell(cell:Vector2i):
	## TODO: 不能把水删除，所以可能也需要一个检查
	erase_cell(cell)
	set_cells_terrain_connect([cell],0,-1) ## 通过设为-1将原本地形清除
