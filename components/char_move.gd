class_name CharMove
extends Node2D

enum LATERAL_MOVE_DIRECTION {
	LEFT = -1, ## 方向：左
	RIGHT = 1, ## 方向：右
	IDLE = 0,  ## 静止不动
}

@export var char_body:CharacterBody2D
@export var char_move_data:CharMoveData

func _ready() -> void:
	assert(char_body,"没有为char-move配置char-body！")


## TODO: 实现移动相关的行动

func lateral_move(delta:float,lateral_move_direction:int):
	char_body.velocity.x = move_toward(char_body.velocity.x,lateral_move_direction * char_move_data.lateral_speed, char_move_data.lateral_speed_acceleration*delta)
	#lateral_jump() ## 对于正常移动，在行为树中可以通过并行节点调用小跳方法。但在气球模式中就不用这个方法避免问题

func lateral_jump():
	if is_on_floor() and !is_meet_wall():
		var lateral_velocity_ratio = abs(char_body.velocity.x) / char_move_data.lateral_speed
		char_body.velocity.y = -1 * (char_move_data.lateral_move_jump * lateral_velocity_ratio)


#region 状态判断
func is_on_floor()->bool:
	return char_body.is_on_floor()

func is_meet_wall()->bool:
	## TODO: 待实现
	return false

#endregion
