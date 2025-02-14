class_name LadderAndWaterMap
extends TileMapLayer

const LADDER_SOURCE_ID := 1

@export var level_data:LevelData
@export_range(0,15) var sunny_water_hight:int = 0
@export_range(0,15) var rain_water_hight:int = 0

var water_hight:int:
	get():
		return sunny_water_hight if not level_data.is_raining else rain_water_hight

func _ready() -> void:
	assert(level_data,"没有为梯子和水地图配置level-data")
	create_water_layer()
	call_deferred("_set_first_layer_water") ## 避免调用顺序问题


func create_ladder_by_cell(cell:Vector2i):
	## TODO: 不能在有水的地方生成，所以可能需要一个检查
	set_cell(cell,LADDER_SOURCE_ID,Vector2i(2,0))
	set_cells_terrain_connect([cell],0,0)

func deleta_ladder_by_cell(cell:Vector2i):
	## TODO: 不能把水删除，所以可能也需要一个检查
	erase_cell(cell)
	set_cells_terrain_connect([cell],0,-1) ## 通过设为-1将原本地形清除

## 根据cell生成水（自动清除梯子，但不确定梯子是否正常变化）
func create_water_by_cell(cell:Vector2i):
	if get_cell_source_id(cell) == LADDER_SOURCE_ID:
		deleta_ladder_by_cell(cell)
	set_cell(cell,0,Vector2i.ZERO,1)

## 根据hight生成水
## TODO:之后需要额外注意，不能在存在外部地图的格子上生成水，这需要一个检查。之前的生成函数最好也加一个这样的检查。
func create_water_layer():
	## 确定生成水的格子数组
	if water_hight == 0:
		return
	
	var top_height := int(LevelData.MAP_SIZE.y) - water_hight
	
	for length in int(LevelData.MAP_SIZE.x):
		for height in range(top_height,LevelData.MAP_SIZE.y):
			var cell := Vector2i(length,height)
			create_water_by_cell(cell)

func _set_first_layer_water():
	for child in get_children():
		if child is Water:
			if local_to_map(child.position).y == int(LevelData.MAP_SIZE.y) - water_hight:
				child.is_first_layer_water = true
		else:
			push_warning("梯子和水地图层的子节点中出现非水的场景")
