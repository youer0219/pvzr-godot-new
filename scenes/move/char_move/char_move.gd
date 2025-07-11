class_name CharMove
extends Node2D

signal twice_jump

@export var char_body:CharacterBody2D
@export var char_move_data:CharMoveData

@onready var ladder_check: RayCast2D = %LadderCheck
@onready var water_check: RayCast2D = %WaterCheck
@onready var clamp_jump_timer: Timer = %ClampJumpTimer


## 从非水区域到水区域时为true。默认为false。当离开水区域或开始上浮后为false。
var is_first_time_on_water:bool = false
## 当前剩余跳跃次数
var current_jump_times:int
## 水线
var water_line:float

func _ready() -> void:
	assert(char_body and char_move_data,"没有为char-move配置char-body或char-move-data！")
	char_move_data.refresh_data()
	current_jump_times = char_move_data.jump_times
	var map_scene = get_tree().get_first_node_in_group("map") as Map
	water_line = map_scene.get_top_water_line()

## TODO: 实现移动相关的行动

## 横向

func lateral_move(delta:float,lateral_move_direction:int):
	char_body.velocity.x = move_toward(char_body.velocity.x,lateral_move_direction * char_move_data.lateral_speed, char_move_data.lateral_speed_acceleration*delta) * char_move_data.lateral_speed_fator


func lateral_jump():
	if is_on_floor() and !is_on_wall():
		var lateral_velocity_ratio = abs(char_body.velocity.x) / char_move_data.lateral_speed
		char_body.velocity.y = -1 * (char_move_data.lateral_move_jump_velocity * lateral_velocity_ratio)

## 纵向

## 突发式

func lengthwise_clamb(_delta:float):
	if clamp_jump_timer.time_left == 0:
		char_body.velocity.y = -1 * char_move_data.clamp_velocity
		clamp_jump_timer.start(char_move_data.clamp_gap_time)

func lengthwise_jump(_delta:float):
	char_body.velocity.y = -1 * char_move_data.jump_velocity

	if char_move_data.jump_times - current_jump_times >= 1 \
	and char_move_data.jump_times > 1:
		char_body.velocity.x += char_move_data.jump_lateral_move * char_body.move_dir
		twice_jump.emit()
	current_jump_times -= 1

func reset_jump_times():
	current_jump_times = char_move_data.jump_times

func limit_velocity_in_first_time_jump_water():
	if is_first_time_on_water:
		char_body.velocity.y = min(char_body.velocity.y , char_move_data.water_init_speed)

## 常态式

func rise_up_in_air(_delta:float):
	pass

## 空中常态重力。存在最大值。
func fall_down_in_air(delta:float):
	char_body.velocity.y = min(char_body.velocity.y + char_move_data.length_down_speed * delta ,\
	char_move_data.MAX_FALL_VELOCITY)

## 水中上浮
func float_up_in_water(_delta:float):
	char_body.velocity.y = -1 * char_move_data.water_up_speed

## 水中下潜
func sink_down_in_water(delta:float):
	char_body.velocity.y = min(char_body.velocity.y + char_move_data.water_down_speed * delta ,\
	char_move_data.MAX_FALL_VELOCITY)

func move_and_slide():
	char_body.move_and_slide()

#region 状态判断

func is_on_floor()->bool:
	return char_body.is_on_floor()

func is_on_wall()->bool:
	return char_body.is_on_wall()

func is_on_ladder()->bool:
	return ladder_check.is_colliding()

func is_on_water()->bool:
	return water_check.is_colliding()

## 能否攀爬。
## 检测到梯子 + （位于地板上 / 不是第一次进入水中）
func can_clamp()->bool:
	if not is_on_ladder():
		return false
	
	if is_on_floor():
		return true
	
	return not is_first_time_on_water

## 能否跳跃
func can_jump()->bool:
	return not is_first_time_on_water and (current_jump_times > 0 or char_move_data.is_endless_jump )

## 能否刷新跳跃次数
func can_reset_jump_times()->bool:
	if is_on_floor():
		return true
	
	if is_on_ladder() and !is_on_water():
		return true
	
	if not is_above_water_line():
		return true
	
	return false

## 水线上下的判断。同时考虑下沉距离。
func is_above_water_line()->bool:
	return char_body.global_position.y < water_line + char_move_data.water_sink_distance

#endregion
