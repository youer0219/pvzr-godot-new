class_name WaterMap
extends TileMapLayer

signal generate_water(cell:Vector2i)


@export var map_data:MapData

var used_cells:Array[Vector2i]

func _ready() -> void:
	assert(map_data,"没有为梯子和水地图配置map_data")

## 根据hight生成水
func create_water_layer(out_map_used_cells:Array[Vector2i]):
	self.used_cells = out_map_used_cells
	
	var water_hight:int = map_data.sunny_water_hight if not map_data.is_raining else map_data.rain_water_hight
	
	if water_hight == 0:
		return
	
	var top_height := int(MapData.MAP_SIZE.y) - water_hight
	
	for length in range(int(MapData.MAP_SIZE.x)):
		for height in range(top_height,MapData.MAP_SIZE.y):
			var cell := Vector2i(length,height)
			_create_water_by_cell(cell)
	
	call_deferred("_update_water_type",top_height) ## 避免调用顺序问题

## 根据cell生成水
func _create_water_by_cell(cell:Vector2i):
	if _is_used_cell(cell):
		return
	
	set_cell(cell, MapData.MAP_SCENE_SOURCE_ID , Vector2i.ZERO , MapData.WATER_SCENE_ID)
	generate_water.emit(cell)

func _update_water_type(top_height:int):
	for child in get_children():
		if child is Water:
			if map_data.is_night_time:
				child.set_water_in_night_time()
			else:
				child.set_water_in_day_time()
			if local_to_map(child.position).y == top_height:
				child.is_first_layer_water = true
		else:
			push_warning("梯子和水地图层的子节点中出现非水的场景")

func _is_used_cell(cell:Vector2i)->bool:
	return used_cells.has(cell)
