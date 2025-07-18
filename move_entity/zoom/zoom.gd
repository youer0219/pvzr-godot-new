extends MoveEntity
class_name Zoom


@onready var entity_path_finder: EntityPathFinder = $EntityPathFinder

const MOVEMENT_THRESHOLD := 8

var target:Node2D ## 考虑单独一个节点或模块来获取target，并使用静态变量避免重复获取
var has_just_move_up:bool

func _ready() -> void:
	super()
	target = get_tree().get_first_node_in_group("dave")

var last_lateral_move_direction:int = 0
var curr_path:Array[Vector2] = []

func _on_chase_state_state_physics_processing(_delta: float) -> void:
	if target == null:
		push_error("target == null")
		return
	
	curr_path = entity_path_finder.get_map_path_to_global_pos(target.global_position)
	
	if curr_path.size() <= 1:
		return
	
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
