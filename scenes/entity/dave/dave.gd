class_name Dave
extends CharacterBody2D

## TODO: 不知道该如何决定图像和碰撞体的位置。这方面等寻路和放置功能实现时再做考虑。

enum DAVE_SPRITE_TYPE {COMMON,ACE,ZOOM}
@export var dave_sprite_type:DAVE_SPRITE_TYPE:set = _set_dave_sprite_type

@onready var image: Sprite2D = %Image
@onready var char_move: CharMove = $CharMove

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


func _physics_process(delta: float) -> void:
	# if 是气球模式
		# 上浮
	if not char_move.is_on_water():
		char_move.has_on_water = false
		char_move.is_first_time_on_water = false
	else:
		char_move.is_first_time_on_water = not char_move.has_on_water
	
	if not is_on_floor():
		if char_move.is_on_water():
			if char_move.is_above_water_line():
				char_move.sink_down_in_water(delta)
			else:
				char_move.float_up_in_water(delta)
				char_move.has_on_water = true
		else:
			char_move.fall_down_in_air(delta)
	
	if char_move.can_reset_jump_times():
		char_move.reset_jump_times()
	
	var direction := Input.get_axis("move_left", "move_right")
	char_move.lateral_move(delta,direction)
	char_move.lateral_jump()
	
	if Input.is_action_pressed("move_up") and char_move.can_clamp():
		char_move.lengthwise_clamb(delta)
	elif Input.is_action_just_pressed("move_up") and char_move.can_jump():
		char_move.lengthwise_jump(delta)
	
	char_move.limit_velocity_in_first_time_jump_water()
	
	char_move.move_and_slide()
