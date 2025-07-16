extends CharacterBody2D
class_name MoveEntity

## TODO:“生成状态”问题：带气球的实体的生成有些不同。但似乎不好设计，可能直接写死。

@onready var char_move: CharMove = $CharMove
@onready var entity_chart: StateChart = %EntityChart
@onready var visual_control: VisualControl = $VisualControl
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var in_ground_check_shape: CollisionShape2D = %InGroundCheckShape

var entity_dir:int:get = get_entity_dir,set = set_entity_dir

var is_just_move_up:bool = false
var is_move_up:bool = false
var lateral_move_direction:int = 0 ## 0表示不动

## 状态标记位
var _was_on_grounded:bool
var _was_on_air:bool
var _was_on_immerse:bool
var _was_on_water_surface:bool

func _ready() -> void:
	char_move.twice_jump.connect(visual_control._on_char_move_twice_jump)
	in_ground_check_shape.shape = collision_shape_2d.shape

func _on_common_state_state_physics_processing(delta: float) -> void:
	if not is_on_floor():
		_was_on_grounded = false
		if char_move.is_on_water():
			_was_on_air = false
			if not _was_on_immerse:
				_was_on_immerse = true
				entity_chart.send_event("immerse")
			if char_move.is_above_water_line():
				if not _was_on_water_surface:
					_was_on_water_surface = true
					entity_chart.send_event("water surface")
			else:
				if _was_on_water_surface:
					_was_on_water_surface = false
					entity_chart.send_event("underwater")
		else:
			_was_on_immerse = false
			_was_on_water_surface = false
			if not _was_on_air:
				_was_on_air = true
				entity_chart.send_event("airborne")
	else:
		_was_on_air = false
		_was_on_immerse = false
		_was_on_water_surface = false
		if not _was_on_grounded:
			_was_on_grounded = true
			entity_chart.send_event("grounded")
	
	if char_move.can_reset_jump_times():
		char_move.reset_jump_times()
	
	_on_lateral_move(delta)

func _on_common_state_state_entered() -> void:
	_was_on_grounded = false
	_was_on_air = false
	_was_on_immerse = false
	_was_on_water_surface = false

func _on_immerse_state_entered() -> void:
	## 启动第一次入水标记，清空跳跃次数，禁止攀爬和跳跃。限制入水初速度。限制横向移动速度。
	char_move.is_first_time_on_water = true
	char_move.current_jump_times = 0
	char_move.limit_velocity_in_first_time_jump_water()
	char_move.char_move_data.lateral_speed_fator = 0.8

func _on_immerse_state_exited() -> void:
	## 无论如何，取消第一次入水标记。停止限制横向移动速度。
	char_move.is_first_time_on_water = false
	char_move.char_move_data.lateral_speed_fator = 1.0

func _on_float_state_entered() -> void:
	## 取消第一次入水标记，重置跳跃次数，允许跳跃和攀爬。
	char_move.is_first_time_on_water = false
	char_move.reset_jump_times()

func _on_airborne_state_physics_processing(delta: float) -> void:
	## 在未攀爬/跳跃时，应用重力
	char_move.fall_down_in_air(delta)

func _on_water_surface_state_physics_processing(delta: float) -> void:
	char_move.sink_down_in_water(delta)

func _on_underwater_state_physics_processing(delta: float) -> void:
	char_move.float_up_in_water(delta)

## 纵向移动处理。仅在地面、空中和水面上时允许触发。
func _on_move_up(delta:float)->void:
	if is_move_up and char_move.can_clamp():
		char_move.lengthwise_clamb(delta)
	elif is_just_move_up and char_move.can_jump():
		char_move.lengthwise_jump(delta)
	
	is_just_move_up = false
	is_move_up = false

## 横向移动处理。每物理帧执行。
func _on_lateral_move(delta:float)->void:
	char_move.lateral_move(delta,lateral_move_direction)
	char_move.lateral_jump()
	
	lateral_move_direction = 0

func get_entity_dir()->int:
	return -1 if visual_control.scale.x < 0 else 1

func set_entity_dir(value:int)->void:
	visual_control.scale.x = value

func _on_balloon_state_state_entered() -> void:
	## image向前偏移90度、碰撞体高度降低
	entity_chart.send_event("lay")

func _on_balloon_state_state_physics_processing(delta: float) -> void:
	## 速度向上；支持横移
	var up_speed := 80.0
	if global_position.y > 0:
		velocity.y = move_toward(velocity.y,-1 * up_speed,delta*50)
	else:
		velocity.y = sqrt(2 * 10 * up_speed) ## TODO:奇怪的公式
	_on_lateral_move(delta)
	move_and_slide()

func _on_balloon_state_state_exited() -> void:
	## 清除进入的效果
	entity_chart.send_event("stand")

func _on_emerge_ground_state_state_entered() -> void:
	## 禁止角色碰撞
	collision_shape_2d.set_deferred("disabled",true)

func _on_emerge_ground_state_state_exited() -> void:
	collision_shape_2d.set_deferred("disabled",false)

func _on_emerge_ground_state_state_physics_processing(delta: float) -> void:
	## 角度为0。位置向上移动。TODO:发射粒子。
	visual_control.rotation_degrees = 0
	position += Vector2(0.0,-30.0) * delta
	velocity = Vector2.ZERO ## 避免图像偏转

func _on_stand_state_state_physics_processing(delta: float) -> void:
	visual_control._on_char_physics_process(delta,self)

func _on_lay_state_state_entered() -> void:
	var tween := create_tween()
	tween.tween_property(visual_control,"rotation_degrees",90 * entity_dir,0.5)
	collision_shape_2d.shape.height *= 0.5

func _on_lay_state_state_exited() -> void:
	var tween := create_tween()
	tween.tween_property(visual_control,"rotation_degrees",0,0.5)
	collision_shape_2d.shape.height *= 2.0

func _on_in_ground_check_area_body_entered(_body: Node2D) -> void:
	entity_chart.send_event("emerge_ground")

func _on_in_ground_check_area_body_exited(_body: Node2D) -> void:
	entity_chart.call_deferred("send_event","common")
