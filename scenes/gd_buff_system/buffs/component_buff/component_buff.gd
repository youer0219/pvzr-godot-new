extends GD_Buff
class_name ComponentBuff


## 堆叠：组件具备同一buff时无限堆叠，当所有组件都离开后才销毁buff。
## 堆叠时增加layers；链接组件离开信号，离开时减少layers；组件数为0时自动销毁buff
## 功能触发：链接组件信号进行处理

const COMPONENT := "COMPONENT"

func _init() -> void:
	default_duration = INF
	is_default_duration_inf = true
	stack_type = STACK_TYPE.STACK
	max_layers = 100
