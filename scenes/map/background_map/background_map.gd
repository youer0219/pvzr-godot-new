class_name BackgroundMap
extends ParallaxBackground

@export var map_data:MapData

@onready var parallax_map_layer: ParallaxLayer = %ParallaxMapLayer

func _process(delta: float) -> void:
	if map_data.is_auto_scroll:
		parallax_map_layer.motion_offset.x += (map_data.auto_scroll_speed * delta)
