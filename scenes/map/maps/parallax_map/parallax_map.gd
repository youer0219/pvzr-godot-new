class_name ParallaxMap
extends ParallaxLayer

const BACK_MOUNTAIN_MAP = preload("res://scenes/map/maps/parallax_map/back_mountain_map/back_mountain_map.tscn")

enum ParallaxMapType {GRESS,SAND}

@export var map_data:MapData:set = _set_map_data

@onready var parallax_map_canvas_group: CanvasGroup = $ParallaxMapCanvasGroup

func _process(delta: float) -> void:
	if map_data.is_auto_scroll:
		motion_offset.x += (map_data.auto_scroll_speed * delta)

func clear_parallax_map():
	for child in parallax_map_canvas_group.get_children():
		child.queue_free()

func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	clear_parallax_map()
	
	if map_data.is_night_time:
		modulate = Color("adadad")
	else:
		modulate = Color(1,1,1,1)
	
	var back_mountain_map := BACK_MOUNTAIN_MAP.instantiate() as BackMountainMap
	
	back_mountain_map.clear()
	
	match map_data.parallax_map_type:
		ParallaxMapType.GRESS:
			back_mountain_map.generate_gress_mountain()
		ParallaxMapType.SAND:
			back_mountain_map.generata_sand_mountain()
	
	parallax_map_canvas_group.add_child(back_mountain_map)
