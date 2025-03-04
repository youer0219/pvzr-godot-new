#*
#* get_node_in_group.gd
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
## 将具有给定索引的场景组中的节点存储在黑板上并返回 [code]SUCCESS[/code]. [br]
## 如果组中没有具有此索引的节点，则返回 [code]FAILURE[/code].


## 节点组名称。
@export var group: StringName = &"some_group"

## 组中的顺序。
@export var index: int = 0

## 存储结果的黑板变量。
@export var result_var: StringName = &"node"


func _generate_name() -> String:
	return "GetNodeInGroup \"%s\"  idx: %s  %s" % [
		group, index, LimboUtility.decorate_output_var(result_var)]


func _tick(_delta: float) -> Status:
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	if index >= nodes.size() or index < 0:
		push_warning("GetNodeInGroup: 在组 \"%s\" 中未找到索引为 %s 的节点" % [group, index])
		return FAILURE

	blackboard.set_var(result_var, nodes[index])
	return SUCCESS
