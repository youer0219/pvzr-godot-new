extends CharacterBody2D
class_name MoveEntity

@onready var char_move: CharMove = $CharMove
@onready var entity_chart: StateChart = %EntityChart
@onready var visual_control: VisualControl = $VisualControl
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var entity_dir:int:get = get_entity_dir,set = set_entity_dir

func _ready() -> void:
	char_move.twice_jump.connect(visual_control._on_char_move_twice_jump)

func _physics_process(_delta: float) -> void:
	pass

func _on_common_state_state_physics_processing(delta: float) -> void:
	if not is_on_floor():
		if char_move.is_on_water():
			entity_chart.send_event("immerse")
			if char_move.is_above_water_line():
				entity_chart.send_event("water surface")
			else:
				entity_chart.send_event("underwater")
		else:
			entity_chart.send_event("airborne")
	else:
		entity_chart.send_event("grounded")
	
	if char_move.can_reset_jump_times():
			char_move.reset_jump_times()
	
	_on_lateral_move(delta)
	
	visual_control._on_char_physics_process(delta,self)


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
func _on_move_up(_delta:float)->void:
	pass

## 横向移动处理。每物理帧执行。
func _on_lateral_move(_delta:float)->void:
	pass

func get_entity_dir()->int:
	return -1 if visual_control.scale.x < 0 else 1

func set_entity_dir(value:int)->void:
	visual_control.scale.x = value

func _on_balloon_state_state_entered() -> void:
	## image向前偏移90度、碰撞体高度降低
	var tween := create_tween()
	tween.tween_callback(visual_control.set_rotation_degrees.bind(0))
	tween.tween_property(visual_control,"rotation_degrees",90 * entity_dir,0.5)
	collision_shape_2d.shape.height *= 0.5

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
	var tween := create_tween()
	tween.tween_property(visual_control,"rotation_degrees",0,0.5)
	collision_shape_2d.shape.height *= 2.0
