@tool
extends BTAction
class_name BTSetLateralDirection

@export var char_move_node:BBNode
@export var method_name:StringName = "lateral_move"

func _generate_name() -> String:
	return "Char-Body Lateral Move by method " + method_name + " with node: %s" % char_move_node

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not char_move_node:
		warnings.append("需要指定节点")
	return warnings

func _tick(delta: float) -> Status:
	if not char_move_node:
		push_error("EmitSignal: 未指定节点")
		return FAILURE

	var char_move_node_inst: CharMove = char_move_node.get_value(scene_root, blackboard) as CharMove
	if not is_instance_valid(char_move_node_inst):
		push_warning("EmitSignal: 无法解析节点参数: " + str(char_move_node))
		return FAILURE
	
	var direction :int = int(Input.get_axis("move_left","move_right"))
	char_move_node_inst.call(method_name,delta,direction)
	return SUCCESS
