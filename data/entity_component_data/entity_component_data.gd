class_name EntityComponentData
extends Resource


@export var init_hp:float = 5.0
@export var component_texture:Texture2D
@export var entity_component_type:EntityComponent.EntityComponentType = EntityComponent.EntityComponentType.MAIN_BODY

@export_group("Action Setting")
@export var component_dead_action_type:EntityComponent.EntityComponentAction = EntityComponent.EntityComponentAction.THROW
@export var common_dead_action_type:EntityComponent.EntityComponentAction = EntityComponent.EntityComponentAction.THROW
@export var ash_dead_action_type:EntityComponent.EntityComponentAction = EntityComponent.EntityComponentAction.NO_ACTION
