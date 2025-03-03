@tool
extends BTAction
class_name BTSetLateralDirection

@export var lateral_direction_var:StringName = &"lateral_direction"


func _generate_name() -> String:
	return "Set Lateral Direction By Input"


func _tick(delta: float) -> Status:
	var direction :int = int(Input.get_axis("move_left","move_right"))
	blackboard.set_var(lateral_direction_var,direction)
	return SUCCESS
