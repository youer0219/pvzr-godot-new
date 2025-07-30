@tool
class_name EntityComponent
extends RigidBody2D

signal component_dead(component:EntityComponent,damage_data:DamageData)
signal component_damaged(component:EntityComponent,damage_data:DamageData)

enum EntityComponentType {
	HEAD,             ## 头
	BODY,             ## 身体
	ACCESSORY_TIER_1, ## I类饰品
	ACCESSORY_TIER_2, ## II类饰品
}

@onready var image: Sprite2D = $Image
@onready var collision_shape: CollisionShape2D = $CollisionShape

@export var entity_component_data: EntityComponentData:set = _set_entity_component_data

var is_in_body := true
var curr_hp: float = 0.0
var phy_enable: bool = false:set = _set_phy_enable

func _set_entity_component_data(value: EntityComponentData) -> void:
	entity_component_data = value
	
	if not is_node_ready():
		await ready
	
	image.texture = entity_component_data.component_texture
	curr_hp = entity_component_data.init_hp ## 只在初始化时set一次，所以是安全的

func _set_phy_enable(value: bool) -> void:
	phy_enable = value
	
	freeze = not phy_enable
	collision_shape.set_deferred("disabled", not phy_enable)

func get_entity_component_type()->EntityComponentType:
	return entity_component_data.component_type

func _on_component_damaged(damage_data:DamageData):
	if entity_component_data.is_offset_damage:
		damage_data.damage = 0
	component_damaged.emit(self,damage_data)

## 单独组件死亡结果
func _on_component_dead(damage_data:DamageData):
	component_dead.emit(self,damage_data)

func _on_entity_common_dead(damage_data:DamageData):
	entity_component_data.apply_component_action(damage_data,self,entity_component_data.component_dead_action)
