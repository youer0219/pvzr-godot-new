# EntityComponentData.gd (组件数据资源)
@tool
class_name EntityComponentData
extends Resource

@export_group("基础设置")
@export var init_hp: float = 5.0
@export var component_texture: Texture2D:set = _set_component_texture
@export var component_type: EntityComponent.EntityComponentType = EntityComponent.EntityComponentType.BODY

@export_group("策略配置")
@export var component_buffs:Array[ComponentBuff]
@export var common_dead_action:ZoomComponentActions.ACTIONS
@export var throw_force:Vector2 = Vector2(80,-200)
@export var is_offset_damage:bool = false

func _set_component_texture(value:Texture2D):
	component_texture = value
	emit_changed()

func apply_component_action(damage_data:DamageData,component:EntityComponent,action:ZoomComponentActions.ACTIONS):
	match action:
		ZoomComponentActions.ACTIONS.THROW:
			ZoomComponentActions.throw_component(damage_data,component,throw_force)
		ZoomComponentActions.ACTIONS.NO_ACTION:
			pass
		_:
			push_warning("组件默认行为中不应该触发其他actions")

func _validate_property(property:Dictionary):
	if not (common_dead_action == ZoomComponentActions.ACTIONS.THROW \
	or common_dead_action == ZoomComponentActions.ACTIONS.THROW):
		if property.name == "throw_force":
			property.usage = PROPERTY_USAGE_NONE
