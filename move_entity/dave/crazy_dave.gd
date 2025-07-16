extends MoveEntity
class_name CrazyDave


func _lengthwise_input_handle():
	if Input.is_action_just_pressed("move_up"):
		is_just_move_up = true
	
	if Input.is_action_pressed("move_up"):
		is_move_up = true

func _lateral_input_handle():
	lateral_move_direction = int(Input.get_axis("move_left", "move_right"))
