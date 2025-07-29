extends CharacterBody2D
class_name Entity

@onready var entity_component_manager: EntityComponentManager = %EntityComponentManager
@onready var entity_path_finder: EntityPathFinder = %EntityPathFinder

var curr_map:Map:
	get:
		return GlobalData.get_data(Map.MAP_KEY)

func _ready() -> void:
	entity_component_manager.entity_component_leave_out.connect(_on_entity_component_leave_out)

func apply_damage(damage_data:DamageData):
	damage_data.target_pos = global_position ## 补充伤害的上下文
	entity_component_manager.apply_damage(damage_data)

func _on_entity_component_leave_out(entity_component:EntityComponent):
	assert(get_parent(),"实体没有父节点，请在正确的环境下测试！")
	entity_component.reparent(get_parent())
