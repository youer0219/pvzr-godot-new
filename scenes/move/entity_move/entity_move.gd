class_name EntityMove
extends Node2D

@export var entity: Entity
@export var floor_ray: RayCast2D

# 移动参数
@export var move_force := 150.0
@export var max_speed := 20.0
@export var small_jump_speed := 120

# 跳跃参数
@export var jump_speed := -250
@export var max_jump_count := 1

var horizontal_damping: float:
	get: return move_force / max_speed

# 跳跃状态跟踪
var jump_remaining := max_jump_count
var was_on_ground := false

func _physics_process(_delta):
	var input_dir = Input.get_axis("move_left", "move_right")
	
	# 地面状态检测
	var is_grounded = is_on_ground()
	
	# 落地时重置跳跃次数
	if is_grounded && !was_on_ground:
		jump_remaining = max_jump_count
	was_on_ground = is_grounded

	# 横向阻尼（保持原有阻尼逻辑）
	var damping_force = -entity.linear_velocity.x * horizontal_damping * entity.mass
	entity.apply_central_force(Vector2(damping_force, 0))

	# 横向移动
	if input_dir != 0:
		if is_grounded:
			# 横移小跳（不消耗次数）
			var target_vy = -small_jump_speed
			var vertical_impulse = entity.mass * (target_vy - entity.linear_velocity.y)
			var speed_ratio = clamp(abs(entity.linear_velocity.x) / max_speed, 0, 1)
			entity.apply_central_impulse(Vector2(0, vertical_impulse * speed_ratio))
		
		# 水平加速
		entity.apply_central_force(Vector2(input_dir * move_force, 0))
	else:
		entity.apply_central_force(Vector2(damping_force * 2, 0))

	# 主跳跃控制（消耗次数）
	if Input.is_action_just_pressed("move_up") && jump_remaining > 0:
		#var needed_impulse = entity.mass * (jump_speed - entity.linear_velocity.y)
		#entity.apply_central_impulse(Vector2(0, needed_impulse))
		entity.linear_velocity.y = jump_speed
		jump_remaining -= 1

func is_on_ground():
	return floor_ray.is_colliding()
