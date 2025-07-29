extends Node2D

@onready var map: Map = $Map

const TEST_DAMAGE_DATA = preload("res://data/damage_data/test_damage_data.tres")
const ZOOM = preload("res://move_entity/zoom/zoom.tscn")

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	var zoom = ZOOM.instantiate()
	var zoom_start_cell := Vector2i(28,18)
	zoom.position = map.map_to_local(zoom_start_cell)
	zoom.start_cell = zoom_start_cell
	add_child(zoom)
	await get_tree().create_timer(4.0).timeout
	var damage_data := TEST_DAMAGE_DATA.duplicate()
	damage_data.damage = 30.0
	zoom.entity_component_manager.apply_damage(damage_data)
	await get_tree().create_timer(4.0).timeout
	damage_data.damage = 20.0
	zoom.entity_component_manager.apply_damage(damage_data)
