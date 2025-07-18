extends MoveEntity
class_name Zoom

## TODO:目前是设定Dave、Zoom层，未来可能改为XXX-hurt层等

@onready var entity_path_finder: EntityPathFinder = $EntityPathFinder
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_check_area: BodyCheckArea = $AttackCheckArea

const MOVEMENT_THRESHOLD := 8

var target:Node2D ## 考虑单独一个节点或模块来获取target，并使用静态变量避免重复获取
var last_lateral_move_direction:int = 0
var curr_path:Array[Vector2]

func _ready() -> void:
	super()
	target = get_tree().get_first_node_in_group("dave")
	attack_timer.timeout.connect(attack)

func attack():
	print(name," attack")

func _on_chase_state_state_physics_processing(_delta: float) -> void:
	if target == null:
		push_error("target == null")
		return
	
	## TODO:直接多帧更新一次，有时僵尸移动会左右摇摆，可能需要一个“到达机制”
	## 如有合适的“到达机制”，可以每0.1s才更新一次路径
	if get_tree().get_frame() % 2 == 0:
		curr_path = entity_path_finder.get_map_path_to_global_pos(target.global_position)
	
	if curr_path.size() >= 2:
		## 横向移动
		if abs(curr_path[1].x - global_position.x) > MOVEMENT_THRESHOLD:
			lateral_move_direction = signi(int(curr_path[1].x - global_position.x))
			last_lateral_move_direction = lateral_move_direction
		else:
			lateral_move_direction = last_lateral_move_direction
		
		## 纵向移动 
		if curr_path[1].y - global_position.y < 0 + entity_pos_deviation:
			is_just_move_up = true
			is_move_up = true
	
	if not attack_check_area.bodys.is_empty():
		entity_chart.send_event("attack")

func _on_attack_state_state_entered() -> void:
	attack()
	attack_timer.start(0.8)

func _on_attack_state_state_exited() -> void:
	attack_timer.stop()

func _on_attack_state_state_physics_processing(_delta: float) -> void:
	if attack_timer.time_left == 0.0:
		if attack_check_area.bodys.is_empty():
			entity_chart.send_event("chase")
		else:
			attack_timer.start(0.8)
