class_name BackgroundMap
extends ParallaxBackground

@export var is_auto_scroll:bool
@export var auto_scroll_speed:int = 300

@onready var parallax_map_layer: ParallaxLayer = %ParallaxMapLayer

func _process(delta: float) -> void:
	if is_auto_scroll:
		parallax_map_layer.motion_offset.x += (auto_scroll_speed * delta)
