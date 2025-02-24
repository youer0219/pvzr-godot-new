class_name ParallaxMap
extends ParallaxLayer


const MOUNTAIN_MAP = preload("res://scenes/map/maps/front_maps/mountain_map/mountain_map.tscn")

enum ParallaxMapType {GRESS,SAND}

@export var map_data:MapData:set = _set_map_data

@onready var parallax_map_canvas_group: CanvasGroup = $ParallaxMapCanvasGroup

func _ready() -> void:
	for child in parallax_map_canvas_group.get_children():
		child.queue_free()

func _process(delta: float) -> void:
	if map_data.is_auto_scroll:
		motion_offset.x += (map_data.auto_scroll_speed * delta)

func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	if map_data.is_night_time:
		modulate = Color("adadad")
	else:
		modulate = Color(1,1,1,1)
	
	var mountain_map := MOUNTAIN_MAP.instantiate() as MountainMap
	
	match map_data.parallax_map_type:
		ParallaxMapType.GRESS:
			mountain_map.mountain_map_type = MountainMap.MOUNTAIN_MAP_TYPE.BACK_MOUNTAIN
		ParallaxMapType.SAND:
			mountain_map.mountain_map_type = MountainMap.MOUNTAIN_MAP_TYPE.BACK_SAND_MOUNTAIN
	
	mountain_map.collision_enabled = false # 在mountain内部已有相关设定，这里重复设定
	parallax_map_canvas_group.add_child(mountain_map)
