class_name FrontMap
extends Node2D

enum FrontMapGenerationType {
	FIXED, ## 固定地图
	RANDOM ## 随机地图。内外部种子一致。
}

@export var map_data:MapData:set = _set_map_data

@onready var inner_canvas_group: CanvasGroup = %InnerCanvasGroup
@onready var outer_canvas_group: CanvasGroup = %OuterCanvasGroup
@onready var water_canvas_group: CanvasGroup = %WaterCanvasGroup
@onready var decorative_parent: CanvasGroup = %DecorativeParent
@onready var water_map: WaterMap = %WaterMap
@onready var ladder_map: TileMapLayer = %LadderMap

var outer_map:TileMapLayer
var inner_map:TileMapLayer

## TODO: 无法解决夜晚水重叠问题。目前勉强符合预期的美术效果。

func _ready() -> void:
	water_map.generate_water.connect(deleta_ladder_by_cell) ## 水的生成会删除梯子但对装饰层无影响

func _generation_front_map():
	_clear_front_map()
	
	match map_data.front_map_gen_type:
		FrontMapGenerationType.FIXED:
			outer_map = map_data.outer_map_scene.instantiate() as TileMapLayer
			outer_map.collision_enabled = true
			outer_canvas_group.add_child(outer_map)
			inner_map = map_data.inner_map_scene.instantiate() as TileMapLayer
			inner_map.collision_enabled = false
			inner_canvas_group.add_child(inner_map)
			if map_data.ladder_map_scene:
				var new_ladder_map_scene = map_data.ladder_map_scene.instantiate()
				generate_ladders_by_cells(get_ladders_form_ladder_map(new_ladder_map_scene))
			if map_data.decorative_map_scene:
				var decorative_map_scene = map_data.decorative_map_scene.instantiate() as TileMapLayer
				decorative_map_scene.collision_enabled = false
				decorative_parent.add_child(decorative_map_scene)
		FrontMapGenerationType.RANDOM:
			var random_seed := RandomMap.get_random_seed()
			outer_map = map_data.random_map_scene.instantiate() as RandomMap
			outer_map.generate_map(random_seed,RandomMap.Type.OUTER)
			outer_canvas_group.add_child(outer_map)
			inner_map = map_data.random_map_scene.instantiate() as RandomMap
			inner_map.generate_map(random_seed,RandomMap.Type.INNER)
			inner_canvas_group.add_child(inner_map)
			var ladder_cells = outer_map.get_random_ladder_cells()
			if ladder_cells:
				generate_ladders_by_cells(ladder_cells)
	
	var water_hight := map_data.rain_water_hight if map_data.is_raining else map_data.sunny_water_hight
	water_map.create_water_layer(outer_map.get_used_cells(),water_hight,map_data.is_night_time)
	
	_delete_extra_ladders_in_raining_day()

func _clear_front_map():
	for child in inner_canvas_group.get_children():
		child.queue_free()
	for child in outer_canvas_group.get_children():
		child.queue_free()
	for child in decorative_parent.get_children():
		child.queue_free()
	ladder_map.clear()
	water_map.clear()

func generate_snow_by_cell(cell:Vector2i):
	if _is_cell_used_in_outer_map(cell) or _is_cell_used_in_water_map(cell) or _is_cell_used_in_ladder_map(cell):
		return
	
	outer_map.set_cell(cell,MapData.MAP_SCENE_SOURCE_ID,Vector2i(0, 0),MapData.SNOW_SCENE_ID)

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

func _delete_extra_ladders_in_raining_day():
	if map_data.is_raining:
		for cell in map_data.extra_delete_ladder_cells_in_raining_day:
			deleta_ladder_by_cell(cell)

func _is_cell_used_in_water_map(cell:Vector2i)->bool:
	return water_map.get_used_cells().has(cell)

func _is_cell_used_in_outer_map(cell:Vector2i)->bool:
	return outer_map.get_used_cells().has(cell)

func _is_cell_used_in_ladder_map(cell:Vector2i)->bool:
	return ladder_map.get_used_cells().has(cell)

func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	if map_data.is_night_time:
		water_canvas_group.self_modulate = Color(1,1,1,1)
		water_canvas_group.modulate = Color("ffffffcd")
	else:
		water_canvas_group.self_modulate = Color("ffffffab")
		water_canvas_group.modulate = Color(1,1,1,1)
	
	_generation_front_map()
