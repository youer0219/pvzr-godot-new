extends BulletMoveStrategy
class_name LinearMoveStrategy

func execute_strategy(delta: float, bullet: Bullet, _context: Dictionary = {}):
	bullet.global_position += delta * bullet.speed * bullet.direction
