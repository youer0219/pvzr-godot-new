extends BulletMoveStrategy
class_name BulletParabolaMoveStrategy

@export var target_pos:Vector2 = Vector2(1,1)
@export var grid_cell:Vector2 = Vector2(16,16)
@export var move_time:float = 1.0

var init_speed:Vector2
var gravity:float

func ready(bullet: Bullet, _context: Dictionary = {}):
	var direction_x = 1 if bullet.bullet_data.direction.x > 0 else -1
	init_speed.x = (direction_x * abs(target_pos.x) * grid_cell.x) / move_time
	init_speed.y = -1 * 2 * (target_pos.y * grid_cell.y) / move_time
	gravity = 2 * (target_pos.y * grid_cell.y) / pow(move_time,2)
	
	bullet.velocity = init_speed

func physics_process(delta: float, bullet: Bullet, _context: Dictionary = {}):
	if not bullet.is_on_floor():
		bullet.velocity.y += gravity * delta
