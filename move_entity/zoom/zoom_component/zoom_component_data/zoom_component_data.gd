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
@export var component_dead_action:ZoomComponentActions.ACTIONS
@export var common_dead_action:ZoomComponentActions.ACTIONS

func _set_component_texture(value:Texture2D):
	component_texture = value
	emit_changed()

## 添加组件时效果
func _on_add_zoom_component(_manager:ZoomComponentManager,_component:ZoomComponent):
	pass

static func apply_component_action(damage_data:DamageData,component:ZoomComponent,action:ZoomComponentActions.ACTIONS):
	match action:
		ZoomComponentActions.ACTIONS.THROW:
			ZoomComponentActions.throw_component(damage_data,component)
		ZoomComponentActions.ACTIONS.NO_ACTION:
			pass
		_:
			push_warning("组件默认行为中不应该触发其他actions")

func _validate_property(property:Dictionary):
	if component_type == ZoomComponent.EntityComponentType.BODY:
		if property.name == "component_dead_strategy":
			property.usage = PROPERTY_USAGE_NONE
