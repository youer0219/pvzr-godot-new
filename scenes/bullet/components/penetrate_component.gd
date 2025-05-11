extends Node
class_name BulletPenetrateComponent

@export var bullet:Bullet

func _ready() -> void:
	bullet.collision_mask = 0
