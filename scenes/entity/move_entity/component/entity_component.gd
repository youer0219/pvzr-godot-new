@tool
class_name EntityComponent
extends RigidBody2D

enum EntityComponentType {
	HEAD,             ## 头
	BODY,             ## 身体
	ACCESSORY_TIER_1, ## I类饰品
	ACCESSORY_TIER_2, ## II类饰品
}

@onready var image: Sprite2D = $Image
@onready var collision_shape: CollisionShape2D = $CollisionShape

@export var zoom_component_data: EntityComponentData:set = _set_zoom_component_data

var is_in_body := true
var curr_hp: float = 0.0
var phy_enable: bool = false:set = _set_phy_enable

func _set_zoom_component_data(value: EntityComponentData) -> void:
	zoom_component_data = value
	
	if not is_node_ready():
		await ready
	
	image.texture = zoom_component_data.component_texture
	curr_hp = zoom_component_data.init_hp ## 只在初始化时set一次，所以是安全的

func _set_phy_enable(value: bool) -> void:
	phy_enable = value
	
	freeze = not phy_enable
	collision_shape.set_deferred("disabled", not phy_enable)

func get_zoom_component_type()->EntityComponentType:
	return zoom_component_data.component_type

## 添加组件时效果
## 未来和buff系统联动，处理额外的组件逻辑.TODO:完善组件信号系统以备组件buff实现
func _on_add_zoom_component(_manager:EntityComponentManager,_component:EntityComponent):
	pass

func _on_component_damaged(damage_data:DamageData):
	if zoom_component_data.is_offset_damage:
		damage_data.damage = 0

## 单独组件死亡结果
func _on_component_dead(damage_data:DamageData):
	EntityComponentData.apply_component_action(damage_data,self,zoom_component_data.common_dead_action)

func _on_zoom_common_dead(damage_data:DamageData):
	EntityComponentData.apply_component_action(damage_data,self,zoom_component_data.component_dead_action)
