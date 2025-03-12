extends Node2D

## 冰冻效果： 6565ff 魅惑效果： ff25ff
const FREEZE_COLOR := Color("6565FF")
const CHARM_COLOR := Color("ff25ff")
const FREEZE_AND_CHARM_COLOR := FREEZE_COLOR * CHARM_COLOR

@onready var canvas_group: CanvasGroup = %CanvasGroup

# 测试颜色混合。发现可以在外部进行颜色乘法，获得混合颜色。
func _ready() -> void:
	canvas_group.material.set_shader_parameter("base_modulate",Color(1,1,1,1))
	await get_tree().create_timer(2.0).timeout
	canvas_group.material.set_shader_parameter("base_modulate",CHARM_COLOR)
	await get_tree().create_timer(2.0).timeout
	canvas_group.material.set_shader_parameter("base_modulate",FREEZE_COLOR)
	await get_tree().create_timer(2.0).timeout
	canvas_group.material.set_shader_parameter("base_modulate",FREEZE_AND_CHARM_COLOR)
