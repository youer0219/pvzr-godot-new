class_name EntityMove
extends Node2D
## 实体移动控制器
##
## 负责处理实体移动、跳跃、爬梯、水面效果等物理行为
## 通过射线检测实现地面和梯子状态判断

#region 配置参数
#------------------------ 节点引用 ------------------------
@export var entity: Entity          # 控制的实体节点
@export var floor_ray01: RayCast2D  # 地面检测射线1
@export var floor_ray02: RayCast2D  # 地面检测射线2 
@export var ladder_ray: RayCast2D   # 梯子检测射线
@export var jump_timer: Timer       # 跳跃冷却计时器

#------------------------ 移动参数 ------------------------
@export var move_force := 150.0     # 横向移动施加的力
@export var max_speed := 20.0       # 最大水平移动速度
@export var small_jump_speed := 150 # 小跳跃初速度 
@export var min_speed_ratio: float = 0.3  # 触发小跳跃的最小速度比例

#------------------------ 跳跃参数 ------------------------
@export var jump_speed := 240.0     # 主跳跃初速度
@export var clamp_speed := 130.0    # 爬梯速度
@export var max_jump_count := 1     # 最大连跳次数
@export var jump_gap_time: float = 0.2  # 跳跃冷却时间
@export var float_speed := 100.0    # 浮空速度（未使用）

#------------------------ 水中参数 ------------------------
@export var can_dive: bool          # 是否允许潜水
@export var sink_offset: float = 8.0 # 水面判定偏移量
#endregion

#region 计算属性
## 横向阻尼系数 = 力 / 最大速度（实现临界阻尼公式）
var horizontal_damping: float:
	get: return move_force / max_speed

## 地面接触状态（任意地面射线碰撞即为接地）
var is_grounded: bool:
	get: return floor_ray01.is_colliding() || floor_ray02.is_colliding()

## 梯子接触状态
var is_on_ladder: bool:
	get: return ladder_ray.is_colliding()

## 跳跃冷却是否结束（考虑浮点误差）
var is_jump_timer_timeout: bool:
	get: return jump_timer.time_left <= 0
#endregion

#region 状态变量
var _velocity: Vector2              # 当前帧计算的临时速度
var _jump_remaining := max_jump_count # 剩余跳跃次数
#endregion

#region 生命周期
func _ready() -> void:
	_reset_jump_timer()
#endregion

#region 公开方法
## 主移动方法：根据输入方向处理所有移动逻辑
func move_by_direction(direction: Vector2) -> void:
	_velocity = entity.linear_velocity  # 获取当前实体速度
	_update_ray_state()                 # 更新射线检测
	
	# 接地时重置跳跃次数
	if is_grounded:
		_reset_jump_counter()
	
	_handle_vertical_movement(direction) # 处理垂直方向运动
	_handle_water_effect()               # 处理水面效果
	_apply_movement()                    # 应用物理冲量
	_handle_horizontal_movement(direction.x) # 处理水平移动
#endregion

#region 移动逻辑
## 处理垂直方向运动（跳跃/爬梯）
func _handle_vertical_movement(direction: Vector2) -> void:
	# 优先级：梯子 > 主跳跃 > 小跳跃
	if direction.y < 0:
		if is_on_ladder && is_jump_timer_timeout:
			_climb_ladder()
		elif _jump_remaining > 0 && is_jump_timer_timeout:
			_perform_main_jump()
	elif is_grounded && direction.x != 0:
		_perform_small_jump()

## 处理水面漂浮效果
func _handle_water_effect() -> void:
	if can_dive:  # 允许潜水时不处理
		return
	
	# 计算水面位置：地图水面高度 + 单元格偏移 - 下沉偏移
	var water_surface = entity.get_map_water_hight_pos_y() + \
					   MapData.MAP_CELL_SIZE.y / 4.0 - \
					   sink_offset
	
	# 当实体位于水面附近时施加浮力
	if entity.position.y >= water_surface:
		_velocity.y = -100  # 固定浮力速度
		_reset_jump_counter() # 接触水面重置跳跃

## 应用计算的速度到实体
func _apply_movement() -> void:
	# 冲量 = 质量 × 速度变化量
	var impulse = entity.mass * (_velocity - entity.linear_velocity)
	entity.apply_central_impulse(impulse)
#endregion

#region 水平移动
## 处理水平移动输入
func _handle_horizontal_movement(input_x: float) -> void:
	_apply_horizontal_damping()  # 先应用阻尼
	
	if input_x == 0:  # 无输入时不施加力
		return
	
	# 根据输入方向施加力
	var move_dir = sign(input_x)
	entity.apply_central_force(Vector2(move_dir * move_force, 0))

## 应用横向阻尼力（实现速度衰减）
func _apply_horizontal_damping() -> void:
	# 阻尼力 = -速度 × 阻尼系数 × 质量
	var damping_force = -entity.linear_velocity.x * horizontal_damping * entity.mass
	entity.apply_central_force(Vector2(damping_force, 0))
#endregion

#region 跳跃系统
## 执行主跳跃
func _perform_main_jump() -> void:
	_velocity.y = -jump_speed  # 设置垂直速度
	_jump_remaining -= 1       # 消耗跳跃次数
	_reset_jump_timer()        # 启动冷却计时

## 爬梯行为
func _climb_ladder() -> void:
	_velocity.y = -clamp_speed  # 固定爬梯速度
	_reset_jump_timer()

## 执行小跳跃（跑跳）
func _perform_small_jump() -> void:
	# 根据水平速度比例计算跳跃力度
	var speed_ratio = clampf(abs(entity.linear_velocity.x) / max_speed, 0, 1)
	#if speed_ratio < min_speed_ratio:
		#return
	_velocity.y = -small_jump_speed * speed_ratio

#endregion

#region 工具方法
## 更新射线检测状态
func _update_ray_state() -> void:
	for ray in [floor_ray01, floor_ray02]:
		ray.force_raycast_update()  # 强制立即更新射线

## 重置跳跃次数
func _reset_jump_counter() -> void:
	_jump_remaining = max_jump_count

## 重置跳跃计时器
func _reset_jump_timer() -> void:
	jump_timer.start(jump_gap_time)
#endregion
