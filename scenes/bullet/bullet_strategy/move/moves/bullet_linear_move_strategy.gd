extends BulletMoveStrategy
class_name LinearMoveStrategy


@export var speed:float = 100.0

func ready(bullet: Bullet, _context: Dictionary = {}):
	bullet.velocity = speed * bullet.direction.normalized()

func physics_process(_delta: float, _bullet: Bullet, _context: Dictionary = {}):
	pass
