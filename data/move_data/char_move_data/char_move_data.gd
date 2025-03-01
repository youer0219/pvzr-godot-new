class_name CharMoveData
extends Resource

const MAX_FALL_VELOCITY := 200

## 横向移动最大速度
@export var lateral_speed:float = 100
## 横向移动加速度
@export var lateral_speed_acceleration:float = 600
## 横向移动小跳
@export var lateral_move_jump:float = 60

## 下落速度
@export var length_down_speed:float = 280


## 可跳跃次数
@export_range(1,2,1) var jump_times:int = 1
@export var jump_lateral_move:float = 120

## 跳跃速度
@export var jump_velocity:float = 120
## 攀爬速度
@export var clamp_velocity:float = 50
@export var clamp_gap_time:float = 0.05

@export var water_init_speed:float = 10
@export var water_down_speed:float = 65
@export var water_up_speed:float = 30
@export var water_sink_distance:float = 4
