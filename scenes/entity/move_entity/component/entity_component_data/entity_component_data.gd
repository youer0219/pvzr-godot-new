# EntityComponentData.gd (组件数据资源)
@tool
class_name EntityComponentData
extends Resource

@export_group("基础设置")
@export var init_hp: float = 5.0
@export var component_texture: Texture2D:set = _set_component_texture
@export var component_type: EntityComponent.EntityComponentType = EntityComponent.EntityComponentType.BODY

@export_group("策略配置")
@export var component_buffs:Array[GD_Buff]
@export var component_dead_buffs:Array[GD_Buff]
@export var common_dead_buffs:Array[GD_Buff]
@export var is_offset_damage:bool = false

func _set_component_texture(value:Texture2D):
	component_texture = value
	emit_changed()
