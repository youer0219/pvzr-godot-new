extends Node2D


@onready var entity_component: EntityComponent = %EntityComponent


func _ready() -> void:
	if not entity_component.is_node_ready():
		await entity_component.ready
	entity_component.ash_head()
