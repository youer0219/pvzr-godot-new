#*
#* emit_signal.gd
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
## 在 [Node] 上发出信号并返回 [code]SUCCESS[/code].
## 如果 [member node] 参数无法提供有效的 [Node] 则返回 [code]FAILURE[/code].

## 指定将发出信号的节点。
@export var node: BBNode

## 指定信号名称。
@export var signal_name: StringName = &"some_signal"

## 指定信号参数（如果有）（最多6个）。
@export var arguments: Array[BBVariant] = []


func _generate_name() -> String:
	return "EmitSignal \"%s\"  node: %s" % [signal_name, node]


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not node:
		warnings.append("指定节点。")
		if arguments.size() > 6:
			warnings.append("参数过多。")
	return warnings


func _tick(_delta: float) -> Status:
	if not node:
		push_error("EmitSignal: 未指定节点")
		return FAILURE

	var node_inst: Node = node.get_value(scene_root, blackboard)
	if not is_instance_valid(node_inst):
		push_warning("EmitSignal: 无法解析节点参数: " + str(node))
		return FAILURE

	match arguments.size():
		0:
			node_inst.emit_signal(signal_name)
		1:
			node_inst.emit_signal(signal_name, arguments[0].get_value(scene_root, blackboard))
		2:
			node_inst.emit_signal(signal_name, arguments[0].get_value(scene_root, blackboard), arguments[1].get_value(scene_root, blackboard))
		3:
			node_inst.emit_signal(signal_name, arguments[0].get_value(scene_root, blackboard), arguments[1].get_value(scene_root, blackboard), arguments[2].get_value(scene_root, blackboard))
		4:
			node_inst.emit_signal(signal_name, arguments[0].get_value(scene_root, blackboard), arguments[1].get_value(scene_root, blackboard), arguments[2].get_value(scene_root, blackboard), arguments[3].get_value(scene_root, blackboard))
		5:
			node_inst.emit_signal(signal_name, arguments[0].get_value(scene_root, blackboard), arguments[1].get_value(scene_root, blackboard), arguments[2].get_value(scene_root, blackboard), arguments[3].get_value(scene_root, blackboard), arguments[4].get_value(scene_root, blackboard))
		6:
			node_inst.emit_signal(signal_name, arguments[0].get_value(scene_root, blackboard), arguments[1].get_value(scene_root, blackboard), arguments[2].get_value(scene_root, blackboard), arguments[3].get_value(scene_root, blackboard), arguments[4].get_value(scene_root, blackboard), arguments[5].get_value(scene_root, blackboard))
		_:
			push_error("EmitSignal: 未发出信号 -- 不支持的参数数量: " + str(arguments.size()))
	return SUCCESS
