extends Node2D

@onready var map: Map = $Map
@onready var zoom: Zoom = $Zoom

const TEST_DAMAGE_DATA = preload("res://data/damage_data/test_damage_data.tres")

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	var damage_data := TEST_DAMAGE_DATA.duplicate()
	damage_data.damage = 10.0
	zoom.entity_component_manager.apply_damage(damage_data)
