class_name BackMountainMap
extends TileMapLayer


const BACK_MOUNTAIN = preload("res://scenes/map/maps/parallax_map/back_mountain_map/mountain_settings/back_mountain.tres")
const BACK_SAND_MOUNTAIN = preload("res://scenes/map/maps/parallax_map/back_mountain_map/mountain_settings/back_sand_mountain.tres")

@onready var heightmap_generator_2d: HeightmapGenerator2D = $HeightmapGenerator2D

func _ready() -> void:
	collision_enabled = false

func generate_gress_mountain():
	if not is_node_ready():
		await ready
	
	heightmap_generator_2d.settings = BACK_MOUNTAIN
	heightmap_generator_2d.generate()

func generata_sand_mountain():
	if not is_node_ready():
		await ready
	
	heightmap_generator_2d.settings = BACK_SAND_MOUNTAIN
	heightmap_generator_2d.generate()
