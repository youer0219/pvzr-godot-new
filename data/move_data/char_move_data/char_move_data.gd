class_name CharMoveData
extends Resource

## 移动数据配置

const MAX_FALL_VELOCITY := 200

## 横向移动最大速度
@export var lateral_speed:float = 100
## 横向移动加速度
@export var lateral_speed_acceleration:float = 600
## 横向移动小跳
@export var lateral_move_jump_distance:float = 4.0
@export var lateral_move_jump_velocity:float = 60

## 下落速度
@export var length_down_speed:float = 280


## 可跳跃次数
@export_range(1,2,1) var jump_times:int = 1
@export var jump_lateral_move:float = 120
@export var is_endless_jump:bool = false

## 跳跃速度
var jump_velocity:float = 120
@export var jump_distance:float = 13
## 攀爬速度
@export var clamp_velocity:float = 50
@export var clamp_gap_time:float = 0.05

@export var water_init_speed:float = 10
@export var water_down_speed:float = 20
@export var water_up_distance:float = 5.0
var water_up_speed:float = 0.0
@export var water_sink_distance:float = 4

## WARNING:需要在ready和改变数据时手动调用该函数重新计算速度等值
## 一般只需要在ready时调用一次
func refresh_data():
	water_up_speed = sqrt(2 * water_down_speed * water_up_distance)
	jump_velocity = sqrt(2 * length_down_speed * jump_distance)
	lateral_move_jump_velocity = sqrt(2 * length_down_speed * lateral_move_jump_distance)
