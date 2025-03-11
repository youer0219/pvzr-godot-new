class_name EntityComponent
extends RigidBody2D

## 禁用时：
## 不受力
## 移动/受击时有一些额外的动作，暂时不知道怎么实现。可能使用动画，所以可能需要设置freeze_mode属性。

## 启动后：
## 与世界层碰撞
## 取消各种其他着色器影响。根据伤害类型决定是否灰烬形态。
## 抛出后有一点弹性。梯子等碰撞体很小，且位于顶部。所以可以达到图像没入地面但仍然弹跳的效果
## 入水后有阻尼效果

signal entity_component_leave_out(entity_component:EntityComponent)
signal entity_component_dead(entity_component:EntityComponent,damage_data:DamageData)
signal entity_component_damaged(entity_component:EntityComponent)
signal entity_component_half_hp(entity_component:EntityComponent)

enum EntityComponentType {
	MAIN_BODY,        # 本体
	ACCESSORY_TIER_1, # I类饰品
	ACCESSORY_TIER_2  # II类饰品
}
enum EntityComponentAction {
	THROW,         ## 抛出
	#MAGNETIC_PULL, ## 被磁力菇吸引.直接通过信号链接应该就好.
	ASH_HEAD,      ## 头的灰烬效果
	ASH_BODY,      ## 身体的灰烬效果
	FREE,          ## 消失。一般用于其他组件的灰烬效果
	NO_ACTION,     ## 无行动
	SPECIAL,       ## 特殊。比如小丑盒子在僵尸一般死亡后触发。
	}

@onready var entity_collision_shape: CollisionShape2D = $EntityCollisionShape
@onready var entity_component_image: EntityComponentImage = $EntityComponentImage

@export var init_hp:float = 5.0
@export var entity_component_type:EntityComponentType = EntityComponentType.MAIN_BODY
@export var phy_enable:bool = false:set = _set_phy_enable

@export_group("Action Setting")
@export var component_dead_action_type:EntityComponentAction = EntityComponentAction.THROW
@export var common_dead_action_type:EntityComponentAction = EntityComponentAction.THROW
@export var ash_dead_action_type:EntityComponentAction = EntityComponentAction.NO_ACTION

var is_in_body := true
var curr_hp:float = init_hp

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	#throw(Vector2i.LEFT.x)
	#apply_magnetic_pull(Vector2.ZERO)
	#ash_body()
	var damage_data = preload("res://data/damage_data/test_damage_data.tres")
	damage_data.target_pos = global_position
	damage_data.from_pos = Vector2.ZERO
	damage_data.damage = 10.0
	damage_data.damage_type = DamageData.DamageType.EXPLOSIVE_DAMAGE
	apply_damage(damage_data)

func _set_phy_enable(value:bool):
	phy_enable = value
	
	if not is_node_ready():
		await ready
	
	## 抛出时启动物理。启动后，实体组件将与world碰撞。不启动时，实体应该静止并不碰撞。
	freeze = not phy_enable
	entity_collision_shape.set_deferred("disabled", not phy_enable)

func apply_damage(damage_data:DamageData)->DamageData:
	if damage_data.damage >= curr_hp:
		damage_data.damage -= curr_hp
		curr_hp = 0
		component_dead(damage_data)
		entity_component_dead.emit(self,damage_data)
	else:
		var has_up_half_hp:bool = curr_hp > init_hp / 2.0
		curr_hp -= damage_data.damage
		if has_up_half_hp and curr_hp < init_hp / 2.0:
			entity_component_half_hp.emit(self)
		damage_data.damage = 0
		entity_component_damaged.emit(self)
	
	return damage_data

func component_dead(damage_data:DamageData):
	apply_entity_component_action(component_dead_action_type,damage_data)

func entity_dead(damage_data:DamageData):
	## 因灰烬伤害死亡
	if damage_data.damage_type == DamageData.DamageType.EXPLOSIVE_DAMAGE:
		apply_entity_component_action(ash_dead_action_type,damage_data)
		return
	## TODO:因碾压伤害死亡。对于僵尸来说并没有什么特殊的，植物会变成扁形。
	## 目前暂时当作一般伤害处理
	
	apply_entity_component_action(common_dead_action_type,damage_data)


func apply_entity_component_action(entity_component_action:EntityComponentAction,damage_data:DamageData):
	match entity_component_action:
		EntityComponentAction.THROW:
			throw(damage_data.get_throw_direction())
		EntityComponentAction.ASH_HEAD:
			ash_head()
		EntityComponentAction.ASH_BODY:
			ash_body()
		EntityComponentAction.FREE:
			queue_free()
		EntityComponentAction.SPECIAL:
			special_action()
		EntityComponentAction.NO_ACTION:
			print(name + " NO_ACTION ")
			pass

func special_action():
	push_error("抽象方法。请实现后再调用。无行动不要使用这个行为类型。")
	pass

func ash_body():
	entity_component_image.ash()
	await get_tree().create_timer(1.25).timeout
	entity_component_image.ash_disapply()
	await get_tree().create_timer(1.25).timeout
	queue_free()

func ash_head():
	entity_component_image.ash()
	await get_tree().create_timer(1.25).timeout
	leave_out()
	phy_enable = true
	await get_tree().create_timer(1.25).timeout
	queue_free()

func apply_magnetic_pull(target_global_pos:Vector2):
	leave_out()
	phy_enable = false
	## TODO:或许要应用一个偏移量来使其正对磁力菇的预估位置
	var tween:Tween = create_tween()
	tween.tween_property(self,"global_position",target_global_pos,0.5)
	tween.tween_interval(25.0)
	tween.tween_callback(self.queue_free)

func can_apply_magnetic_pull()->bool:
	return not is_in_body

func throw(direction:int):
	leave_out()
	phy_enable = true
	
	var tween:Tween = create_tween()
	apply_impulse(Vector2(direction * 80 , -400))
	tween.tween_interval(3.0)
	tween.tween_callback(self.queue_free)

func leave_out():
	entity_component_leave_out.emit(self)
	is_in_body = false
	## TODO:清理Image的冰冻状态。但似乎不影响魅惑状态。不过现在冰冻没实现，之后处理。
