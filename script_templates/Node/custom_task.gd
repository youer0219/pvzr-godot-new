# meta-name: Custom Task
# meta-description: Custom task to be used in a BehaviorTree
# meta-default: true
@tool
extends BTTask
## 自定义任务类


# 显示自定义名称（需要 @tool）。
func _generate_name() -> String:
	return "Custom Task"


# 初始化时调用一次。
func _setup() -> void:
	pass


# 每次进入此任务时调用。
func _enter() -> void:
	pass


# 每次退出此任务时调用。
func _exit() -> void:
	pass


# 每次此任务被 tick（即执行）时调用。
func _tick(delta: float) -> Status:
	return SUCCESS


# 此方法返回的字符串会在行为树编辑器中显示为警告（需要 @tool）。
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
