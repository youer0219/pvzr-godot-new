class_name Map
extends Node2D

enum MapGenerationType {
	FIXED, ## 固定地图
	RANDOM ## 随机地图。内外部种子一致。
}

@export var map_data:MapData:set = _set_map_data

@onready var inner_canvas_group: CanvasGroup = %InnerCanvasGroup
@onready var outer_canvas_group: CanvasGroup = %OuterCanvasGroup
@onready var decorative_parent: CanvasGroup = %DecorativeParent
@onready var bottom_map: BottomMap = %BottomMap
@onready var parallax_map: ParallaxMap = %ParallaxMap
@onready var water_map: WaterMap = %WaterMap
@onready var ladder_map: TileMapLayer = %LadderMap

var outer_map:TileMapLayer
var inner_map:TileMapLayer

## TODO: 水的效果、内部地图的效果都不知道该怎么处理才能实现与原版一致的效果

func _ready() -> void:
	water_map.generate_water.connect(deleta_ladder_by_cell) ## 水的生成会删除梯子但对装饰层无影响
	_generation_front_map()

func _generation_front_map():
	_clear_front_map()
	
	match map_data.map_gen_type:
		MapGenerationType.FIXED:
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
		MapGenerationType.RANDOM:
			var seed := RandomMap.get_random_seed()
			outer_map = map_data.random_map_scene.instantiate() as RandomMap
			outer_map.generate_map(seed,RandomMap.Type.OUTER)
			outer_canvas_group.add_child(outer_map)
			inner_map = map_data.random_map_scene.instantiate() as RandomMap
			inner_map.generate_map(seed,RandomMap.Type.INNER)
			inner_canvas_group.add_child(inner_map)
			var ladder_cells = outer_map.get_random_ladder_cells()
			if ladder_cells:
				generate_ladders_by_cells(ladder_cells)
	if map_data.decorative_map_scene:
		var decorative_map_scene = map_data.decorative_map_scene.instantiate() as TileMapLayer
		decorative_map_scene.collision_enabled = false
		decorative_parent.add_child(decorative_map_scene)
	
	delete_extra_ladders()

func _clear_front_map():
	for child in inner_canvas_group.get_children():
		child.queue_free()
	for child in outer_canvas_group.get_children():
		child.queue_free()
	for child in decorative_parent.get_children():
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

func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	bottom_map.map_data = map_data
	parallax_map.map_data = map_data
	water_map.map_data = map_data
	## 如果放在_generation_front_map中，会比map_data的设置先执行，导致问题
	water_map.create_water_layer(outer_map.get_used_cells())
