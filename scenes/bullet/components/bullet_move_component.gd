extends Node
class_name BaseBulletMoveComponent

@export var bullet:Bullet


func _physics_process(delta: float) -> void:
	if bullet:
		bullet.global_position += delta * bullet.direction * bullet.speed
