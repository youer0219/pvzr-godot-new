extends BulletMoveStrategy
class_name BulletSeekingMoveStrategy

@export var normal_speed: float = 120.0    # 追踪时的移动速度
@export var idle_speed: float = 30.0      # 无目标时的低速
@export var rotation_speed: float = 120.0  # 转向速度（度/秒）

@export var target_group:String = "enemy"

var initial_direction: Vector2             # 初始方向缓存
var current_target: Node2D = null          # 当前追踪目标

func ready(bullet: Bullet, _context: Dictionary = {}):
	# 保存初始方向并初始化速度
	initial_direction = bullet.direction.normalized()
	bullet.velocity = initial_direction * idle_speed

func physics_process(delta: float, bullet: Bullet, _context: Dictionary = {}):
	# 获取敌人组并筛选有效目标
	var enemies = bullet.get_tree().get_nodes_in_group(target_group).filter(
		func(enemy): return is_instance_valid(enemy)
	)
	
	if enemies.is_empty():
		# 无目标时低速直线运动
		bullet.velocity = initial_direction * idle_speed
		current_target = null
	else:
		# 选择第一个可见目标
		current_target = enemies[0]
		var target_pos = current_target.global_position
		
		# 计算转向
		var to_target = (target_pos - bullet.global_position).normalized()
		var current_dir = bullet.velocity.normalized()
		
		# 计算转向角度差
		var angle_diff = rad_to_deg(current_dir.angle_to(to_target))
		var rotation_step = rotation_speed * delta
		
		# 根据角度差调整方向
		if angle_diff > rotation_step:
			bullet.velocity = bullet.velocity.rotated(deg_to_rad(rotation_step))
		elif angle_diff < -rotation_step:
			bullet.velocity = bullet.velocity.rotated(deg_to_rad(-rotation_step))
		else:
			bullet.velocity = to_target * normal_speed
		
		# 保持速度恒定
		bullet.velocity = bullet.velocity.normalized() * normal_speed
