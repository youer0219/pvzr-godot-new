extends Node2D


@onready var entity_component: EntityComponent = %EntityComponent


func _ready() -> void:
	if not entity_component.is_node_ready():
		await entity_component.ready
	
	test_entity_component_damage_apply()

func test_entity_component_damage_apply():
	var damage_data:DamageData = preload("res://data/damage_data/test_damage_data.tres")
	damage_data.damage = 100.0
	damage_data.damage_type = DamageData.DamageType.EXPLOSIVE_DAMAGE
	entity_component.apply_damage(damage_data)
	await get_tree().create_timer(1.5).timeout
	entity_component.apply_damage(damage_data)
