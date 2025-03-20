@tool
extends BTTask
## 自定义任务类

var agent_node:Entity

# 显示自定义名称（需要 @tool）。
func _generate_name() -> String:
	return "Entity Task"

# 每次此任务被 tick（即执行）时调用。
func _tick(_delta: float) -> Status:
	
	return SUCCESS

# 此方法返回的字符串会在行为树编辑器中显示为警告（需要 @tool）。
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings

# 初始化时调用一次。
func _setup() -> void:
	if not agent is Entity:
		push_error("这是专属于代理为entity的任务！")
	agent_node = agent

# 每次进入此任务时调用。
func _enter() -> void:
	pass

# 每次退出此任务时调用。
func _exit() -> void:
	pass
