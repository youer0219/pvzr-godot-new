extends CharacterBody2D
class_name MoveEntity

@onready var char_move: CharMove = $CharMove
@onready var entity_chart: StateChart = %EntityChart
@onready var visual_control: VisualControl = $VisualControl
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var in_ground_check_shape: CollisionShape2D = %InGroundCheckShape
@onready var entity_component_manager: EntityComponentManager = $EntityComponentManager
@onready var gd_buff_container: GD_BuffContainer = $GD_BuffContainer

@onready var grounded: AtomicState = %Grounded
@onready var airborne: AtomicState = %Airborne
@onready var immerse: CompoundState = %Immerse
@onready var water_surface: AtomicState = %"Water Surface"
@onready var underwater: AtomicState = %Underwater

## 偏差值 用于改进AI的纵向移动 或许会重构image位置，使之无用
@export var entity_pos_deviation:float = 6 ## TODO:目前只在zoom中使用，需要评估是否必要
@export var entity_data:EntityData:set = _set_entity_data

var entity_dir:int:get = get_entity_dir,set = set_entity_dir

var is_just_move_up:bool = false
var is_move_up:bool = false
var lateral_move_direction:int = 0 ## 0表示不动

func _ready() -> void:
	char_move.twice_jump.connect(visual_control._on_char_move_twice_jump)
	in_ground_check_shape.shape = collision_shape_2d.shape
	entity_component_manager.add_component_buffs.connect(gd_buff_container.add_buffs)

func _set_entity_data(data:EntityData)->void:
	entity_data = data
	if not is_node_ready():
		await ready
	entity_component_manager.clear_entity_components()
	entity_component_manager.add_entity_components(entity_data.entity_component_datas)

func _on_common_state_state_physics_processing(delta: float) -> void:
	if not is_on_floor():
		if char_move.is_on_water():
			if not immerse.active:
				entity_chart.send_event("immerse")
			if char_move.is_above_water_line():
				if not water_surface.active:
					entity_chart.send_event("water surface")
			elif not underwater.active:
				entity_chart.send_event("underwater")
		elif not airborne.active:
			entity_chart.send_event("airborne")
	elif not grounded.active:
		entity_chart.send_event("grounded")
	
	if char_move.can_reset_jump_times():
		char_move.reset_jump_times()
	
	_on_lateral_move(delta)

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
	## 进入倒地状态；向上初速度
	entity_chart.send_event("lay")
	velocity.y = -40

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
	## 回到站立状态
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
	collision_shape_2d.shape.height *= 0.25
	char_move.char_move_data.water_sink_distance += 5

func _on_lay_state_state_exited() -> void:
	var tween := create_tween()
	tween.tween_property(visual_control,"rotation_degrees",0,0.5)
	collision_shape_2d.shape.height *= 4.0
	char_move.char_move_data.water_sink_distance -= 5

## TODO: 这里通过记录body数量来判断是否进入/退出会更精确
func _on_in_ground_check_area_body_entered(_body: Node2D) -> void:
	entity_chart.send_event("emerge_ground")

func _on_in_ground_check_area_body_exited(_body: Node2D) -> void:
	entity_chart.call_deferred("send_event","common")
