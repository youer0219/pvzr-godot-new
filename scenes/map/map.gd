class_name Map
extends Node2D

enum InternalMapGenerationType {
	INTERNAL_FIXED, ## 内部地图固定
	INTERNAL_MATCH_EXTERNAL_SCENE, ## 内部地图与外部地图场景一致
	INTERNAL_MATCH_EXTERNAL_SEED   ## 内部地图与外部地图种子一致
}

@export var map_data:MapData

@onready var inner_canvas_group: CanvasGroup = %InnerCanvasGroup
@onready var outer_canvas_group: CanvasGroup = %OuterCanvasGroup
@onready var water_map: WaterMap = %WaterMap
@onready var ladder_map: TileMapLayer = %LadderMap

var outer_map:TileMapLayer
var inner_map:TileMapLayer

func _ready() -> void:
	water_map.generate_water.connect(deleta_ladder_by_cell)
	_generation_front_map()

func _generation_front_map():
	_clear_front_map()
	
	match map_data.inner_map_gen_type:
		InternalMapGenerationType.INTERNAL_FIXED:
			outer_map = map_data.outer_map_scene.instantiate() as TileMapLayer
			outer_map.collision_enabled = true
			outer_canvas_group.add_child(outer_map)
			assert(map_data.inner_map_scene,"地图类型为固定内部场景，但没有配置相关场景！")
			inner_map = map_data.inner_map_scene.instantiate() as TileMapLayer
			inner_map.collision_enabled = false
			inner_canvas_group.add_child(inner_map)
			if map_data.ladder_map_scene:
				var new_ladder_map_scene = map_data.ladder_map_scene.instantiate()
				generate_ladders_by_cells(get_ladders_form_ladder_map(new_ladder_map_scene))
		InternalMapGenerationType.INTERNAL_MATCH_EXTERNAL_SCENE:
			push_error("未实现相关操作！")
		InternalMapGenerationType.INTERNAL_MATCH_EXTERNAL_SEED:
			push_error("未实现相关操作！")
	
	delete_extra_ladders()
	
	water_map.create_water_layer(outer_map.get_used_cells())

## ladder处理：
## 获取固定地图ladder的cells再生成即可
## 大楼等随机地形需要随机生成梯子，要把梯子cells传递出来

func _clear_front_map():
	for child in inner_canvas_group.get_children():
		child.queue_free()
	for child in outer_canvas_group.get_children():
		child.queue_free()
	ladder_map.clear()
	water_map.clear()

func generate_ladder_by_cell(cell:Vector2i):
	if _is_cell_used_in_outer_map(cell) or _is_cell_used_in_water_map(cell):
		return
	
	ladder_map.set_cell(cell,MapData.LADDER_SOURCE_ID,Vector2i(2,0))
	ladder_map.set_cells_terrain_connect([cell],0,0)

func deleta_ladder_by_cell(cell:Vector2i):
	ladder_map.erase_cell(cell)
	ladder_map.set_cells_terrain_connect([cell],0,-1) ## 通过设为-1将原本地形清除

func generate_ladders_by_cells(cells:Array[Vector2i]):
	for cell in cells:
		generate_ladder_by_cell(cell)

func get_ladders_form_ladder_map(new_ladder_map:TileMapLayer)->Array[Vector2i]:
	return new_ladder_map.get_used_cells_by_id(MapData.LADDER_SOURCE_ID)

func delete_extra_ladders():
	if map_data.is_raining:
		for cell in map_data.extra_delete_ladder_cells:
			deleta_ladder_by_cell(cell)

func _is_cell_used_in_water_map(cell:Vector2i)->bool:
	return water_map.get_used_cells().has(cell)

func _is_cell_used_in_outer_map(cell:Vector2i)->bool:
	return outer_map.get_used_cells().has(cell)
