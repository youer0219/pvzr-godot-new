class_name EntityMove
extends Node2D

@export var entity: Entity
@export var floor_ray01: RayCast2D
@export var floor_ray02: RayCast2D
@export var ladder_ray:RayCast2D
@export var jump_timer:Timer

# 移动参数
@export var move_force := 150.0
@export var max_speed := 20.0
@export var small_jump_speed := 150
@export var min_speed_radio:float = 0.3

# 跳跃参数
@export var jump_speed := 225.0
@export var clamp_speed := 130.0
@export var max_jump_count := 1
@export var jump_gap_time:float = 0.2

@export var float_speed := 100.0

var horizontal_damping: float:
	get: return move_force / max_speed
var is_grounded:bool:
	get:
		return floor_ray01.is_colliding() or floor_ray02.is_colliding()
var is_on_ladder:bool:
	get:
		return ladder_ray.is_colliding()
var is_jump_timer_timeout:bool:
	get:
		return jump_timer.time_left == 0

var velocity:Vector2
var jump_remaining := max_jump_count

func _ready() -> void:
	_jump_timer_restart()

func _physics_process(_delta):
	velocity = entity.linear_velocity
	
	update_ray_state()
	
	var input_dir = Input.get_axis("move_left", "move_right")
	
	# 地面状态检测
	if is_grounded:
		update_jump_counter()
	
	# 处理跳跃优先级
	if Input.is_action_pressed("move_up") && is_on_ladder && is_jump_timer_timeout:
		clamb_ladder()
	elif Input.is_action_just_pressed("move_up") && jump_remaining > 0 && is_jump_timer_timeout:
		main_jump()
	elif input_dir != 0 and is_grounded:
		small_jump()
	
	# 应用冲量
	var impulse = entity.mass * (velocity - entity.linear_velocity)
	entity.apply_central_impulse(impulse)
	
	# 处理水平移动
	handle_horizontal_damping()
	handle_horizontal_movement(input_dir)

func update_jump_counter():
	jump_remaining = max_jump_count

func handle_horizontal_damping():
	# 应用横向阻尼力
	var damping_force = -entity.linear_velocity.x * horizontal_damping * entity.mass
	entity.apply_central_force(Vector2(damping_force, 0))

func main_jump():
	velocity.y = -1 * jump_speed
	jump_remaining -= 1
	_jump_timer_restart()

func clamb_ladder():
	velocity.y = -1 * clamp_speed
	_jump_timer_restart()

func small_jump():
	var speed_ratio = clamp(abs(entity.linear_velocity.x) / max_speed,0, 1)
	if speed_ratio <= min_speed_radio:
		return
	velocity.y = -1 * small_jump_speed * speed_ratio

func handle_horizontal_movement(input_dir: float):
	# 处理横向移动输入
	if input_dir != 0:
		entity.apply_central_force(Vector2(input_dir * move_force, 0))

func update_ray_state():
	floor_ray01.force_raycast_update()
	floor_ray02.force_raycast_update()

func _jump_timer_restart():
	jump_timer.start(jump_gap_time)
