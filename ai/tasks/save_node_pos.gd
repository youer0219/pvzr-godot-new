#*
#* save_node_pos.gd
#* =============================================================================
#* 版权所有 2024 Serhii Snitsaruk
#*
#* 使用本源代码受 MIT 风格许可证约束，
#* 可在 LICENSE 文件中找到，或访问
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
@tool
extends BTAction
## SaveNodePos 将节点的位置保存到黑板上并返回 [code]SUCCESS[/code].


## 指定节点。
@export var node: BBNode = BBNode.new()

## 指定存储结果的黑板变量。
@export var position_var: StringName = &"target_pos"


func _generate_name() -> String:
	return "SaveNodePos %s  %s" % [
			node,
			LimboUtility.decorate_output_var(position_var),
		]


func _tick(_delta: float) -> Status:
	var node_inst = node.get_value(scene_root, blackboard) # 注意：未指定类型以支持 Node2D 和 Node3D
	if not is_instance_valid(node_inst):
		push_warning("SaveNodePos: 无法解析节点参数: " + str(node))
		return FAILURE

	blackboard.set_var(position_var, node_inst.global_position)
	return SUCCESS
