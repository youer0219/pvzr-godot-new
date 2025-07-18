extends MoveEntity
class_name CrazyDave

func _ready() -> void:
	super()
	### 等待5s，模拟受伤
	#await get_tree().create_timer(5.0).timeout
	#entity_chart.send_event("hurt")
	### 等待5s，模拟受伤且一半血以下
	#await get_tree().create_timer(5.0).timeout
	#entity_chart.send_event("hurt")
	#entity_chart.send_event("half_hp")
	### 等待10s，模拟退出受伤状态
	#await get_tree().create_timer(5.0).timeout
	#$"EntityChart/ParallelState/ActionState/On Common Move".take()

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

func _on_common_hurt_state_state_entered() -> void:
	## 倒地；碰撞体调整；
	entity_chart.send_event("lay")

func _on_common_hurt_state_state_exited() -> void:
	## 回正；碰撞体恢复；
	entity_chart.send_event("stand")

func _on_hurt():
	## 尝试状态转换 TODO:（可以判断是否无敌）；粒子效果；判断是否半血以触发气球模式
	## TODO:刷新计时器，一定时间后退出受伤状态
	entity_chart.send_event("hurt")
