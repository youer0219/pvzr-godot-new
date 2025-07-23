class_name ZoomComponentCanvasGroup
extends CanvasGroup

## 冰冻效果： 6565ff 魅惑效果： ff25ff 
const FREEZE_COLOR := Color("6565ff")
const CHARM_COLOR  := Color("ff25ff")
const BLOOD_COLOR  := Color(1,0,0,1)

@export var blink_color:Color = Color(1,1,1,1)


## 提供所有的entity-component数组。如果混入意外值会报错。
func get_entity_components()->Array[ZoomComponent]:
	## 第三个参数写内置类名，不写class-name声明的类名
	return Array(get_children(),TYPE_OBJECT,"RigidBody2D",ZoomComponent)

## 清除所有组件
func clear_entity_components():
	for child in get_children():
		child.queue_free()

## 震动方法
func shake(value:float):
	material.set_shader_parameter("shake_intensity",clampf(value,0.0,1.0))

## 闪烁方法
func blink():
	material.set_shader_parameter("blink_color",blink_color)
	var tween = create_tween()
	tween.tween_method(_set_blink_intensity,0.0,0.7,0.15)
	tween.tween_method(_set_blink_intensity,0.7,0.3,0.15)
	tween.tween_callback(_set_blink_intensity.bind(0))

func _set_blink_intensity(value:float):
	material.set_shader_parameter("blink_intensity", value)

## 冰冻/魅惑
func apply_modulate_color(color:Color):
	material.set_shader_parameter("base_modulate",color)
