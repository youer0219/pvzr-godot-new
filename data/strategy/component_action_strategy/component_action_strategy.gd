# component_action_strategy.gd (策略接口)
class_name ComponentActionStrategy
extends Resource

@export var strategy_name:String

func _to_string() -> String:
	return strategy_name

func execute(_component: ZoomComponent,_damage_data: DamageData) -> void:
	push_error("抽象方法需实现")

## 一般策略需要组件未离开时才允许执行。
func can_execute(component: ZoomComponent,_damage_data: DamageData)->bool:
	return component.is_in_body
