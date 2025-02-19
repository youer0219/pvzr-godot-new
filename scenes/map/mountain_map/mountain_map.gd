class_name MountainMap
extends TileMapLayer


const BACK_MOUNTAIN = preload("res://scenes/map/mountain_map/mountain_settings/back_mountain.tres")
const BACK_SAND_MOUNTAIN = preload("res://scenes/map/mountain_map/mountain_settings/back_sand_mountain.tres")
const MOUNTAIN = preload("res://scenes/map/mountain_map/mountain_settings/mountain.tres")

const COLLISION_MAP_TILE_SET = preload("res://scenes/map/map_tilesets/collision_map_tile_set.tres")
const MAP_TILE_SET = preload("res://scenes/map/map_tilesets/map_tile_set.tres")

@onready var heightmap_generator_2d: HeightmapGenerator2D = $HeightmapGenerator2D

enum MOUNTAIN_MAP_TYPE {
	MOUNTAIN, ## 前景。草地山。
	BACK_MOUNTAIN, ## 背景。草地山。
	BACK_SAND_MOUNTAIN, ## 背景。沙地山。
	}
@export var mountain_map_type:MOUNTAIN_MAP_TYPE:set = _set_mountain_map_type

func _set_mountain_map_type(value:MOUNTAIN_MAP_TYPE):
	mountain_map_type = value
	
	if not is_node_ready():
		await ready
	
	clear()
	
	match mountain_map_type:
		MOUNTAIN_MAP_TYPE.MOUNTAIN:
			tile_set = COLLISION_MAP_TILE_SET
			heightmap_generator_2d.settings = MOUNTAIN
		MOUNTAIN_MAP_TYPE.BACK_MOUNTAIN:
			tile_set = MAP_TILE_SET
			heightmap_generator_2d.settings = BACK_MOUNTAIN
		MOUNTAIN_MAP_TYPE.BACK_SAND_MOUNTAIN:
			tile_set = MAP_TILE_SET
			heightmap_generator_2d.settings = BACK_SAND_MOUNTAIN
	
	heightmap_generator_2d.generate()
