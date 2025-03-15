extends RigidBody2D


@onready var entity_component_manager: EntityComponentManager = %EntityComponentManager


func _ready() -> void:
	entity_component_manager.entity_component_leave_out.connect(_on_entity_component_leave_out)




func _on_entity_component_leave_out(entity_component:EntityComponent):
	assert(get_parent(),"实体没有父节点，请在正确的环境下测试！")
	entity_component.reparent(get_parent())
