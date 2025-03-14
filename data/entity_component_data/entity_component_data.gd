# EntityComponentData.gd (组件数据资源)
class_name EntityComponentData
extends Resource

@export_group("基础设置")
@export var init_hp: float = 5.0
@export var component_texture: Texture2D
@export var component_type: EntityComponent.EntityComponentType = EntityComponent.EntityComponentType.MAIN_BODY

@export_group("策略配置")
@export var component_dead_strategy: ComponentActionStrategy
@export var common_dead_strategy: ComponentActionStrategy
@export var ash_dead_strategy: ComponentActionStrategy
