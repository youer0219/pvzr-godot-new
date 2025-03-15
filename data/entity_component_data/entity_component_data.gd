# EntityComponentData.gd (组件数据资源)
@tool
class_name EntityComponentData
extends Resource

@export_group("基础设置")
@export var init_hp: float = 5.0
@export var has_hp:bool = true
@export var component_texture: Texture2D:set = _set_component_texture
@export var component_type: EntityComponent.EntityComponentType = EntityComponent.EntityComponentType.MAIN_BODY

@export_group("策略配置")
@export var component_dead_strategy: ComponentActionStrategy
@export var common_dead_strategy: ComponentActionStrategy
@export var ash_dead_strategy: ComponentActionStrategy


func _set_component_texture(value:Texture2D):
	component_texture = value
	emit_changed()


func _validate_property(property:Dictionary):
	if component_type == EntityComponent.EntityComponentType.MAIN_BODY:
		if property.name == "component_dead_strategy":
			property.usage = PROPERTY_USAGE_NONE
