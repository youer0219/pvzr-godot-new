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
	update_jump_counter(is_grounded)
	handle_horizontal_damping()
	
	# 处理跳跃优先级
	var vertical_impulse = handle_main_jump()
	if vertical_impulse == 0:
		vertical_impulse = handle_small_jump(input_dir, is_grounded)
	
	# 应用垂直冲量
	if vertical_impulse != 0:
		entity.apply_central_impulse(Vector2(0, vertical_impulse))
	
	# 处理水平移动
	handle_horizontal_movement(input_dir)

func update_jump_counter(is_grounded: bool):
	# 落地时重置跳跃次数
	if is_grounded && !was_on_ground:
		jump_remaining = max_jump_count
	was_on_ground = is_grounded

func handle_horizontal_damping():
	# 应用横向阻尼力
	var damping_force = -entity.linear_velocity.x * horizontal_damping * entity.mass
	entity.apply_central_force(Vector2(damping_force, 0))

func handle_main_jump() -> float:
	# 主跳跃逻辑（空中允许二段跳）
	if Input.is_action_just_pressed("move_up") && jump_remaining > 0:
		var impulse = entity.mass * (jump_speed - entity.linear_velocity.y)
		jump_remaining -= 1
		return impulse
	return 0.0

func handle_small_jump(input_dir: float, is_grounded: bool) -> float:
	# 横移小跳逻辑（仅地面生效）
	if is_grounded && input_dir != 0:
		var target_vy = -small_jump_speed
		var speed_ratio = clamp(abs(entity.linear_velocity.x) / max_speed, 0, 1)
		return entity.mass * (target_vy - entity.linear_velocity.y) * speed_ratio
	return 0.0

func handle_horizontal_movement(input_dir: float):
	# 处理横向移动输入
	if input_dir != 0:
		entity.apply_central_force(Vector2(input_dir * move_force, 0))

func is_on_ground():
	return floor_ray.is_colliding()
