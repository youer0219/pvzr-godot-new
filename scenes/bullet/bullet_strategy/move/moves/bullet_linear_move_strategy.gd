extends BulletMoveStrategy
class_name LinearMoveStrategy


func ready(bullet: Bullet, _context: Dictionary = {}):
	if not enable:
		return
	bullet.velocity = bullet.speed * bullet.direction.normalized()

func physics_process(_delta: float, _bullet: Bullet, _context: Dictionary = {}):
	pass
