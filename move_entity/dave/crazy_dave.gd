extends MoveEntity
class_name CrazyDave

## TODO:要重写气球相关方法，因为戴夫可能不会在触碰天花板后立即退出该模式
## 而是在退出hurt模式后一并退出气球模式。同时倒地等功能是否重合呢？

func _lengthwise_input_handle():
	if Input.is_action_just_pressed("move_up"):
		is_just_move_up = true
	
	if Input.is_action_pressed("move_up"):
		is_move_up = true

func _lateral_input_handle():
	lateral_move_direction = int(Input.get_axis("move_left", "move_right"))

func _on_bolloon_hurt_state_state_entered() -> void:
	entity_chart.send_event("balloon")

func _on_bolloon_hurt_state_state_exited() -> void:
	entity_chart.send_event("common")

func _on_hurt_state_state_entered() -> void:
	## 倒地；碰撞体调整；
	pass # Replace with function body.

func _on_hurt_state_state_exited() -> void:
	## 回正；碰撞体恢复；
	pass # Replace with function body.

func _on_hurt():
	## 尝试状态转换 TODO:（可以判断是否无敌）；粒子效果；判断是否半血以触发气球模式
	## TODO:刷新计时器，一定时间后退出受伤状态
	entity_chart.send_event("hurt")
