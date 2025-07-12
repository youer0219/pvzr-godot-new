extends MoveEntity
class_name CrazyDave



func _on_move_up(delta:float)->void:
	if Input.is_action_pressed("move_up") and char_move.can_clamp():
		char_move.lengthwise_clamb(delta)
	elif Input.is_action_just_pressed("move_up") and char_move.can_jump():
		char_move.lengthwise_jump(delta)

func _on_lateral_move(delta:float)->void:
	var direction := Input.get_axis("move_left", "move_right")
	char_move.lateral_move(delta,int(direction))
	char_move.lateral_jump()
