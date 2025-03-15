extends Node2D

@onready var entity: RigidBody2D = $Entity


func _ready() -> void:
	
	await get_tree().create_timer(1.5).timeout
	
	var damage_data:DamageData = preload("res://data/damage_data/test_damage_data.tres").duplicate()
	damage_data.damage_type = DamageData.DamageType.EXPLOSIVE_DAMAGE
	for i in range(10):
		damage_data.damage = 5.0
		await get_tree().create_timer(0.4).timeout
		entity.apply_damage(damage_data)
