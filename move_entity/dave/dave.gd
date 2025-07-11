class_name Dave
extends CharacterBody2D

## TODO: 不知道该如何决定图像和碰撞体的位置。这方面等寻路和放置功能实现时再做考虑。

enum DAVE_SPRITE_TYPE {COMMON,ACE,ZOOM}
@export var dave_sprite_type:DAVE_SPRITE_TYPE:set = _set_dave_sprite_type

@onready var image: Sprite2D = %Image
@onready var char_move: CharMove = $CharMove
@onready var entity_chart: StateChart = %EntityChart

var image_dir:int:
	get:
		return -1 if image.flip_h else 1

func _set_dave_sprite_type(value:DAVE_SPRITE_TYPE):
	dave_sprite_type = value
	
	if not is_node_ready():
		await ready
	
	match dave_sprite_type:
		## TODO:这样的实现可能着色器会有一些问题，要对齐UV和区域？
		DAVE_SPRITE_TYPE.COMMON:
			image.region_rect = Rect2(74,0,16,32)
		DAVE_SPRITE_TYPE.ACE:
			image.region_rect = Rect2(42,0,16,32)
		DAVE_SPRITE_TYPE.ZOOM:
			image.region_rect = Rect2(10,0,16,32)

func _ready() -> void:
	char_move.twice_jump.connect(
		func():
			var tween:Tween = create_tween()
			tween.tween_property(image,"rotation_degrees",360 * image_dir,0.25)
			tween.tween_callback(image.set_rotation.bind(0))
	)

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
	
	var direction := Input.get_axis("move_left", "move_right")
	char_move.lateral_move(delta,int(direction))
	char_move.lateral_jump()
	
	if velocity.x > 0:
		image.flip_h = false
	elif velocity.x < 0:
		image.flip_h = true
	
	var rotation_degress = 15 * (velocity.x / char_move.char_move_data.lateral_speed)
	image.rotation_degrees = move_toward(image.rotation_degrees,rotation_degress,delta*200)

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

func _on_move_up(delta:float)->void:
	if Input.is_action_pressed("move_up") and char_move.can_clamp():
		char_move.lengthwise_clamb(delta)
	elif Input.is_action_just_pressed("move_up") and char_move.can_jump():
		char_move.lengthwise_jump(delta)
