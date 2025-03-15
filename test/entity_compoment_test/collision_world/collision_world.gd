extends Node2D


@onready var entity_component: EntityComponent = %EntityComponent


func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	$EntityComponentManager.entity_component_leave_out.connect(
		func(new_entity_component:EntityComponent):
			new_entity_component.reparent(self)
	)
	
	var damage_data:DamageData = preload("res://data/damage_data/test_damage_data.tres").duplicate()
	damage_data.damage_type = DamageData.DamageType.EXPLOSIVE_DAMAGE
	for i in range(10):
		damage_data.damage = 5.0
		await get_tree().create_timer(0.4).timeout
		$EntityComponentManager.apply_damage(damage_data)


func test_entity_component_damage_apply():
	var damage_data:DamageData = preload("res://data/damage_data/test_damage_data.tres")
	damage_data.damage = 1
	damage_data.damage_type = DamageData.DamageType.EXPLOSIVE_DAMAGE
	entity_component.apply_damage(damage_data)
	await get_tree().create_timer(1.5).timeout
	entity_component.apply_damage(damage_data)
