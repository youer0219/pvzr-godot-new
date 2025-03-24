class_name EntityMove
extends Node2D

@export var entity: Entity
@export var floor_ray01: RayCast2D
@export var floor_ray02: RayCast2D

# 移动参数
@export var move_force := 150.0
@export var max_speed := 20.0
@export var small_jump_speed := 150
@export var min_speed_radio:float = 0.3

# 跳跃参数
@export var jump_speed := -225
@export var max_jump_count := 1

var horizontal_damping: float:
	get: return move_force / max_speed
var is_grounded:bool:
	get:
		return floor_ray01.is_colliding() or floor_ray02.is_colliding()

var jump_remaining := max_jump_count

func _physics_process(_delta):
	update_ray_state()
	
	var input_dir = Input.get_axis("move_left", "move_right")
	
	# 地面状态检测
	update_jump_counter()
	handle_horizontal_damping()
	
	# 处理跳跃优先级
	var vertical_impulse = handle_main_jump()
	if vertical_impulse == 0 and input_dir != 0:
		vertical_impulse = handle_small_jump()
	
	# 应用垂直冲量
	if vertical_impulse != 0:
		entity.apply_central_impulse(Vector2(0, vertical_impulse))
	
	# 处理水平移动
	handle_horizontal_movement(input_dir)

func update_jump_counter():
	if is_grounded:
		jump_remaining = max_jump_count

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

func handle_small_jump() -> float:
	# 横移小跳逻辑（仅地面生效）
	if is_grounded:
		var target_vy = -small_jump_speed
		var speed_ratio = clamp(abs(entity.linear_velocity.x) / max_speed,0, 1)
		if speed_ratio <= min_speed_radio:
			return 0.0
		return entity.mass * (target_vy - entity.linear_velocity.y) * speed_ratio
	return 0.0

func handle_horizontal_movement(input_dir: float):
	# 处理横向移动输入
	if input_dir != 0:
		entity.apply_central_force(Vector2(input_dir * move_force, 0))

func update_ray_state():
	floor_ray01.force_raycast_update()
	floor_ray02.force_raycast_update()
