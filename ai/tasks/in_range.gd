#*
#* in_range.gd
#* =============================================================================
#* 版权所有 2021-2024 Serhii Snitsaruk
#*
#* 使用本源代码受 MIT 风格许可证约束，
#* 可在 LICENSE 文件中找到，或访问
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
@tool
extends BTCondition
## InRange 条件检查代理是否在目标范围内，
## 由 [member distance_min] 和 [member distance_max] 定义。 [br]
## 如果代理在给定范围内，则返回 [code]SUCCESS[/code];
## 否则，返回 [code]FAILURE[/code].

## 到目标的最小距离。
@export var distance_min: float

## 到目标的最大距离。
@export var distance_max: float

## 存储目标的黑板变量（期望类型为 [Node2D]）。
@export var target_var: StringName = &"target"

var _min_distance_squared: float
var _max_distance_squared: float


# 调用以生成任务的显示名称。
func _generate_name() -> String:
	return "InRange (%d, %d) of %s" % [distance_min, distance_max,
		LimboUtility.decorate_var(target_var)]


# 调用以初始化任务。
func _setup() -> void:
	## 小性能优化
	_min_distance_squared = distance_min * distance_min
	_max_distance_squared = distance_max * distance_max


# 调用以执行任务。
func _tick(_delta: float) -> Status:
	var target: Node2D = blackboard.get_var(target_var, null)
	if not is_instance_valid(target):
		push_warning("InRange: 目标不是有效的 Node2D (%s: %s)" % [
				LimboUtility.decorate_var(target_var), blackboard.get_var(target_var)])
		return FAILURE

	var dist_sq: float = agent.global_position.distance_squared_to(target.global_position)
	if dist_sq >= _min_distance_squared and dist_sq <= _max_distance_squared:
		return SUCCESS
	else:
		return FAILURE
