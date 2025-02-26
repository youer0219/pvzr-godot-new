class_name Map
extends Node2D

enum MapGenerationType {
	FIXED, ## 固定地图
	RANDOM ## 随机地图。内外部种子一致。
}

@export var map_data:MapData:set = _set_map_data

@onready var front_map: FrontMap = %FrontMap
@onready var bottom_map: BottomMap = %BottomMap
@onready var parallax_map: ParallaxMap = %ParallaxMap

func generate_ladder_by_cell(cell:Vector2i):
	front_map.generate_ladder_by_cell(cell)

func deleta_ladder_by_cell(cell:Vector2i):
	front_map.deleta_ladder_by_cell(cell)

func generate_snow_by_cell(cell:Vector2i):
	front_map.generate_snow_by_cell(cell)

func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	bottom_map.map_data = map_data
	parallax_map.map_data = map_data
	front_map.map_data = map_data
