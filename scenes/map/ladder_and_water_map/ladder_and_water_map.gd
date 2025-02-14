class_name LadderAndWaterMap
extends TileMapLayer

const LADDER_SOURCE_ID := 1
const WATER_SOURCE_ID := 0

@export var level_data:LevelData

## TODO: 具体的值还是应该由level-data决定。但需要先实现map选择并保存一个映射关系
@export_range(0,15) var sunny_water_hight:int = 0
@export_range(0,15) var rain_water_hight:int = 0

var used_cells:Array[Vector2i]

func _ready() -> void:
	assert(level_data,"没有为梯子和水地图配置level-data")

func create_ladder_by_cell(cell:Vector2i):
	if _is_used_cell(cell):
		push_warning("尝试在已使用的格子上生成梯子")
		return
	if _is_water_cell(cell):
		push_warning("尝试在水的格子上生成梯子！")
		return
	
	set_cell(cell,LADDER_SOURCE_ID,Vector2i(2,0))
	set_cells_terrain_connect([cell],0,0)

func deleta_ladder_by_cell(cell:Vector2i):
	if _is_water_cell(cell):
		push_warning("尝试在水的格子上删除梯子！")
		return
	
	erase_cell(cell)
	set_cells_terrain_connect([cell],0,-1) ## 通过设为-1将原本地形清除

## 根据hight生成水
func create_water_layer():
	var water_hight:int = sunny_water_hight if not level_data.is_raining else rain_water_hight
	
	if water_hight == 0:
		return
	
	var top_height := int(LevelData.MAP_SIZE.y) - water_hight
	
	for length in range(int(LevelData.MAP_SIZE.x)):
		for height in range(top_height,LevelData.MAP_SIZE.y):
			var cell := Vector2i(length,height)
			if not _is_used_cell(cell):
				_create_water_by_cell(cell)
	
	call_deferred("_set_first_layer_water",top_height) ## 避免调用顺序问题

## 根据cell生成水
func _create_water_by_cell(cell:Vector2i):
	if get_cell_source_id(cell) == LADDER_SOURCE_ID:
		deleta_ladder_by_cell(cell)
	set_cell(cell, WATER_SOURCE_ID , Vector2i.ZERO , 1)

func _set_first_layer_water(top_height:int):
	for child in get_children():
		if child is Water:
			if local_to_map(child.position).y == top_height:
				child.is_first_layer_water = true
		else:
			push_warning("梯子和水地图层的子节点中出现非水的场景")

func _is_water_cell(cell:Vector2i)->bool:
	return get_cell_source_id(cell) == 0

func _is_used_cell(cell:Vector2i)->bool:
	return used_cells.has(cell)
