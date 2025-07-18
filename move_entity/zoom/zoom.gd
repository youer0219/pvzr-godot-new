extends MoveEntity
class_name Zoom


@onready var entity_path_finder: EntityPathFinder = $EntityPathFinder

const MOVEMENT_THRESHOLD := 8

var target:Node2D ## 考虑单独一个节点或模块来获取target，并使用静态变量避免重复获取

func _ready() -> void:
	super()
	target = get_tree().get_first_node_in_group("dave")

var last_lateral_move_direction:int = 0

func _on_chase_state_state_physics_processing(_delta: float) -> void:
	if target == null:
		push_error("target == null")
		return
	
	if abs(target.global_position.x - global_position.x) > MOVEMENT_THRESHOLD:
		lateral_move_direction = signi(target.global_position.x - global_position.x)
		last_lateral_move_direction = lateral_move_direction
	else:
		lateral_move_direction = last_lateral_move_direction
