extends Resource
class_name BulletMoveStrategy

func ready(_bullet: Bullet, _context: Dictionary = {}):
	assert(false, "This method must be overridden")

func physics_process(_delta: float, _bullet: Bullet, _context: Dictionary = {}):
	assert(false, "This method must be overridden")
