extends CharacterBody2D
class_name MoveEntity

@onready var char_move: CharMove = $CharMove
@onready var entity_chart: StateChart = %EntityChart
@onready var visual_control: VisualControl = $VisualControl

var move_dir:int:
	get:
		return -1 if visual_control.scale.x < 0 else 1

func _ready() -> void:
	char_move.twice_jump.connect(visual_control._on_char_move_twice_jump)

func _physics_process(delta: float) -> void:
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
