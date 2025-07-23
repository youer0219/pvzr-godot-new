# ZoomComponentData.gd (组件数据资源)
@tool
class_name ZoomComponentData
extends Resource

@export_group("基础设置")
@export var init_hp: float = 5.0
@export var has_hp:bool = true
@export var is_main_body:bool = false
@export var component_texture: Texture2D:set = _set_component_texture
@export var component_type: ZoomComponent.EntityComponentType = ZoomComponent.EntityComponentType.BODY

@export_group("策略配置")
@export var component_dead_strategy: ComponentActionStrategy
@export var common_dead_strategy: ComponentActionStrategy
@export var ash_dead_strategy: ComponentActionStrategy


func _set_component_texture(value:Texture2D):
	component_texture = value
	emit_changed()

## 添加组件时效果
func _on_add_zoom_component(_manager:ZoomComponentManager,_component:ZoomComponent):
	pass

## 移除组件时效果  
## TODO:暂时不知道如何应用比较好，目前打算用来清除add的信号连接，但在哪调用没有头绪
func _on_remove_zoom_component(_manager:ZoomComponentManager,_component:ZoomComponent):
	pass

## 单独组件死亡结果
func _on_component_dead(damage_data:DamageData,component:ZoomComponent,):
	ZoomComponentActions.throw_component(damage_data,component,Vector2(80,-200))


func _validate_property(property:Dictionary):
	if component_type == ZoomComponent.EntityComponentType.BODY:
		if property.name == "component_dead_strategy":
			property.usage = PROPERTY_USAGE_NONE
