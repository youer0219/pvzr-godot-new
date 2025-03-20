class_name EntityMove
extends Node2D


@export var entity:Entity
@export var floor_ray:RayCast2D

@export var move_force := 300.0       # 水平移动力
@export var max_speed := 120.0        # 期望的最大水平速度
@export var horizontal_jump_impulse := 20.0  # 横移时的跳跃冲量
@export var jump_impulse := 120.0     # 跳跃冲量

# 自动计算阻尼系数
var horizontal_damping: float:
	get: return move_force / max_speed


func _physics_process(_delta):
	var input_dir = Input.get_axis("move_left", "move_right")
	
	# 应用移动力和速度阻尼
	if input_dir != 0:
		if is_on_ground():
			entity.apply_central_impulse(Vector2(0, -horizontal_jump_impulse))
		
		var move_dir = Vector2(input_dir, 0)
		# 施加移动力
		entity.apply_central_force(move_dir * move_force)
		
		# 施加横向阻尼力（与速度方向相反）
		var damping_force = -entity.linear_velocity.x * horizontal_damping * entity.mass
		entity.apply_central_force(Vector2(damping_force, 0))
	
	# 地面检测和跳跃（保持原有逻辑）
	#floor_ray.force_raycast_update()
	if Input.is_action_just_pressed("move_up") and is_on_ground():
		entity.apply_central_impulse(Vector2(0, -jump_impulse))

func is_on_ground():
	return floor_ray.is_colliding()
