@tool
class_name BTCheckInput
extends BTCondition



enum InputType {
	JUST_PRESSED,  ## 刚刚按下
	PRESSED,       ## 按下
	JUST_RELEASED, ## 刚刚释放
}

@export var input_name:StringName
@export var input_type:InputType = InputType.JUST_PRESSED


func _generate_name() -> String:
	return "Check Input: " + input_name + " by method: " + input_method_name[input_type]

var input_method_name := {
	InputType.JUST_PRESSED:"is_action_just_pressed",
	InputType.PRESSED:"is_action_pressed",
	InputType.JUST_RELEASED:"is_action_just_released",
}

func _tick(_p_delta: float) -> Status:
	if Input.call(input_method_name[input_type],input_name):
		return SUCCESS
	return FAILURE
