@tool
class_name EntityComponent
extends RigidBody2D

enum EntityComponentType {
	MAIN_BODY,        ## 本体
	ACCESSORY_TIER_1, ## I类饰品
	ACCESSORY_TIER_2, ## II类饰品
}

signal entity_component_leave_out(entity_component: EntityComponent)
signal entity_component_damaged(entity_component: EntityComponent)
#signal entity_component_half_hp(entity_component: EntityComponent)

signal entity_dead(damage_data: DamageData)

@onready var entity_collision_shape: CollisionShape2D = $EntityCollisionShape
@onready var entity_component_image: Sprite2D = $EntityComponentImage

@export var entity_component_data: EntityComponentData:set = _set_entity_component_data

var is_in_body := true
var curr_hp: float = 0.0
var phy_enable: bool = false:set = _set_phy_enable

func _set_entity_component_data(value: EntityComponentData) -> void:
	entity_component_data = value
	
	if not is_node_ready():
		await ready
	if not entity_component_data.changed.is_connected(_set_component_texture):
		entity_component_data.changed.connect(_set_component_texture)
	_set_component_texture()
	curr_hp = entity_component_data.init_hp ## 只在初始化时set一次，所以是安全的

func _set_component_texture():
	entity_component_image.texture = entity_component_data.component_texture

func _set_phy_enable(value: bool) -> void:
	phy_enable = value
	
	freeze = not phy_enable
	entity_collision_shape.set_deferred("disabled", not phy_enable)

func apply_damage(damage_data: DamageData):
	if entity_component_data.has_hp:
		if damage_data.damage >= curr_hp:
			if curr_hp > 0:
				damage_data.damage -= curr_hp
				curr_hp = 0
			if entity_component_data.component_type == EntityComponentType.MAIN_BODY:
				## 本体类组件没有组件死亡策略，依靠上层触发实体死亡函数决定死亡策略
				entity_dead.emit(damage_data)
			else:
				component_dead(damage_data)
		else:
			#var has_up_half_hp: bool = curr_hp > entity_component_data.init_hp / 2.0
			## 这里不作限制。因为考虑到治疗类型的伤害，虽然更应该单独处理。
			curr_hp -= damage_data.damage
			#if has_up_half_hp and curr_hp < entity_component_data.init_hp / 2.0:
				#entity_component_half_hp.emit(self)
			damage_data.damage = 0
			entity_component_damaged.emit(self)


func component_dead(damage_data: DamageData) -> void:
	_execute_strategy(entity_component_data.component_dead_strategy,damage_data)

func on_entity_dead(damage_data: DamageData) -> void:
	if damage_data.damage_type == DamageData.DamageType.EXPLOSIVE_DAMAGE:
		_execute_strategy(entity_component_data.ash_dead_strategy,damage_data)
	else:
		_execute_strategy(entity_component_data.common_dead_strategy,damage_data)

func leave_out() -> void:
	entity_component_leave_out.emit(self)
	is_in_body = false

func get_entity_component_type()->EntityComponentType:
	return entity_component_data.component_type

func _execute_strategy(strategy:ComponentActionStrategy,damage_data:DamageData):
	if strategy:
		if strategy.can_execute(self,damage_data):
			strategy.execute(self, damage_data)
	else:
		push_warning("没有配置组件行为策略")
