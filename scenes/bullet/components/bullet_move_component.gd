extends Node
class_name BaseBulletMoveComponent

@export var bullet:Bullet


func _physics_process(delta: float) -> void:
	if bullet:
		bullet.linear_velocity = bullet.speed * bullet.direction
