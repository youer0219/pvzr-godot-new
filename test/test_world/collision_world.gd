extends Node2D

@onready var map: Map = $Map
@onready var common_zoom: Zoom = $Node2D/CommonZoom

const TEST_DAMAGE_DATA = preload("res://data/damage_data/test_damage_data.tres")
const ZOOM = preload("uid://ci0rsdebt11t8")
const TEST_ZOOM = preload("res://data/entity_data/entities/zoom/test_zoom.tres")
func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	var zoom = ZOOM.instantiate()
	var zoom_start_cell := Vector2i(28,18)
	zoom.position = map.map_to_local(zoom_start_cell)
	zoom.start_cell = zoom_start_cell
	zoom.entity_data = TEST_ZOOM.duplicate()
	$Map.add_child(zoom)
	await get_tree().create_timer(4.0).timeout
	var damage_data := TEST_DAMAGE_DATA.duplicate()
	damage_data.damage = 30.0
	zoom.entity_component_manager.apply_damage(damage_data)
	await get_tree().create_timer(4.0).timeout
	damage_data.damage = 20.0
	zoom.entity_component_manager.apply_damage(damage_data)
	damage_data.damage = 30.0
	zoom.entity_component_manager.apply_damage(damage_data)
	damage_data.damage = 30.0
	zoom.entity_component_manager.apply_damage(damage_data)


## TODO: 能否为僵尸的移动添加一些随机性
## TODO: zombie被错误写成zoom了！
