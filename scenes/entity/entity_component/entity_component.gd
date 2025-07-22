@tool
class_name EntityComponent
extends RigidBody2D

enum EntityComponentType {
	HEAD,             ## 头
	BODY,             ## 身体
	ACCESSORY_TIER_1, ## I类饰品
	ACCESSORY_TIER_2, ## II类饰品
}

@onready var entity_collision_shape: CollisionShape2D = $EntityCollisionShape
@onready var entity_component_image: Sprite2D = $EntityComponentImage

@export var entity_component_data: EntityComponentData:set = _set_entity_component_data

var is_in_body := true
var is_ash:bool = false
var curr_hp: float = 0.0
var phy_enable: bool = false:set = _set_phy_enable

func _set_entity_component_data(value: EntityComponentData) -> void:
	entity_component_data = value
	
	if not is_node_ready():
		await ready
	
	entity_component_image.texture = entity_component_data.component_texture
	curr_hp = entity_component_data.init_hp ## 只在初始化时set一次，所以是安全的

func _set_phy_enable(value: bool) -> void:
	phy_enable = value
	
	freeze = not phy_enable
	entity_collision_shape.set_deferred("disabled", not phy_enable)

func leave_out() -> void:
	is_in_body = false

func get_entity_component_type()->EntityComponentType:
	return entity_component_data.component_type

func _on_component_dead(_damage_data:DamageData):
	pass
