# EntityComponentData.gd (组件数据资源)
class_name EntityComponentData
extends Resource

@export_group("基础设置")
@export var name:String
@export var init_hp: float = 5.0
@export var component_texture: Texture2D
@export var component_type: EntityComponent.EntityComponentType = EntityComponent.EntityComponentType.BODY

@export_group("策略配置")
@export var component_buffs:Array[GD_Buff]
@export var component_dead_buffs:Array[GD_Buff]
@export var common_dead_buffs:Array[GD_Buff]
@export var is_offset_damage:bool = false
