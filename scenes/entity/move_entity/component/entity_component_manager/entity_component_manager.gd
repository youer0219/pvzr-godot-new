extends Node2D
class_name EntityComponentManager

signal entity_dead(damage_data:DamageData)
signal add_component_buffs(buffs:Array[GD_Buff])

const ENTITY_COMPONENT = preload("uid://d27ql2svxqnsf")

@export var substance_canvas_group:EntityComponentCanvasGroup
@export var accessory_one_entity_component:EntityComponentCanvasGroup
@export var accessory_two_entity_component:EntityComponentCanvasGroup

@onready var last_global_position:Vector2 = self.global_position

func _physics_process(_delta: float) -> void:
	accessory_one_entity_component.global_position = last_global_position
	accessory_two_entity_component.global_position = last_global_position
	last_global_position = global_position

## 应用伤害的方法
func apply_damage(damage_data:DamageData):
	damage_data.context["dead_components"] = []
	damage_data.context["damaged_components"] = []
	
	## 先不考虑忽视防具的情况，计算顺序是：二类、一类和本体(本体可能划分为头和身体)
	## 计算中，如果伤害归0，中止伤害应用；如果防具血量归0，触发移除防具方法(_on_component_dead)
	## 存在中断伤害效果，可以由防具自身设计(_on_damage)
	for component in get_accessory_two_entity_components():
		if damage_data.damage <= 0:
			break
		_component_damage_apply(damage_data,component)
	
	for component in get_accessory_one_entity_components():
		if damage_data.damage <= 0:
			break
		_component_damage_apply(damage_data,component)
	
	var head_component := get_head_entity_component()
	if head_component != null:
		if damage_data.damage > 0:
			_component_damage_apply(damage_data,head_component)
		if head_component.curr_hp <= 0:
			_on_entity_dead(damage_data)
		else:
			_on_entity_damaged(damage_data)
	else:
		_on_entity_dead(damage_data)

func _component_damage_apply(damage_data:DamageData,component:EntityComponent):
	var hp := component.curr_hp
	component.curr_hp -= damage_data.damage
	damage_data.damage -= hp
	component._on_component_damaged(damage_data)
	if component.curr_hp <= 0:
		damage_data.context["dead_components"].append(component)
	else:
		damage_data.context["damaged_components"].append(component)

func add_entity_components(entity_component_datas:Array[EntityComponentData]):
	for entity_component_data:EntityComponentData in entity_component_datas:
		add_entity_component(entity_component_data)

func add_entity_component(entity_component_data:EntityComponentData):
	var new_entity_component = ENTITY_COMPONENT.instantiate() as EntityComponent
	new_entity_component.entity_component_data = entity_component_data
	
	match entity_component_data.component_type:
		EntityComponent.EntityComponentType.HEAD:
			substance_canvas_group.add_child(new_entity_component)
		EntityComponent.EntityComponentType.BODY:
			substance_canvas_group.add_child(new_entity_component)
		EntityComponent.EntityComponentType.ACCESSORY_TIER_1:
			accessory_one_entity_component.add_child(new_entity_component)
		EntityComponent.EntityComponentType.ACCESSORY_TIER_2:
			accessory_two_entity_component.add_child(new_entity_component)
	
	## add component buff
	_add_buffs(entity_component_data.component_buffs,new_entity_component)
	
	new_entity_component.component_buffs_apply.connect(_add_buffs.bind(new_entity_component))

func clear_entity_components():
	substance_canvas_group.clear_entity_components()
	accessory_one_entity_component.clear_entity_components()
	accessory_two_entity_component.clear_entity_components()

func _add_buffs(buffs:Array[GD_Buff],component:EntityComponent):
	for buff in buffs:
		## TODO:因为buff本身并不会本地化，所以这一修改由所有buff共享，这是很危险的！
		buff.init_buff_blackboard["component"] = component
	if not buffs.is_empty():
		add_component_buffs.emit(buffs)

#region 事件信号处理
## 处理实体组件死亡信号的方法
## 根据造成死亡的伤害类型调用组件的各个方法

func _on_entity_dead(damage_data:DamageData):
	## 分为灰烬类和非灰烬类不同处理
	## 目前只关心非灰烬类
	
	## TODO:目前是调用所有的组件的eead回调，但这是否必要需要研究
	for component in get_all_components():
		component._on_entity_common_dead(damage_data)
	
	entity_dead.emit(damage_data)

func _on_entity_damaged(damage_data:DamageData):
	## 二类  一类和本体
	var dead_components = damage_data.context["dead_components"]
	for component:EntityComponent in dead_components:
		component._on_component_dead(damage_data)
	
	var damaged_components = damage_data.context["damaged_components"] as Array
	if damaged_components.any(
		func(component:EntityComponent):
			return component.get_entity_component_type() == EntityComponent.EntityComponentType.ACCESSORY_TIER_2
	):
		accessory_two_entity_component.blink()
	if damaged_components.any(
		func(component:EntityComponent):
			return component.get_entity_component_type() == EntityComponent.EntityComponentType.ACCESSORY_TIER_1 \
			or component.get_entity_component_type() == EntityComponent.EntityComponentType.HEAD \
			or component.get_entity_component_type() == EntityComponent.EntityComponentType.BODY
	):
		accessory_one_entity_component.blink()
		substance_canvas_group.blink()

#endregion

#region 获取某类/所有组件的方法

func get_head_entity_component()->EntityComponent:
	for component in get_substance_entity_components():
		if component.get_entity_component_type() == EntityComponent.EntityComponentType.HEAD:
			return component
	return null

func get_substance_entity_components()->Array[EntityComponent]:
	return substance_canvas_group.get_entity_components()

func get_accessory_one_entity_components()->Array[EntityComponent]:
	return accessory_one_entity_component.get_entity_components()

func get_accessory_two_entity_components()->Array[EntityComponent]:
	return accessory_two_entity_component.get_entity_components()

func get_accessory_entity_components()->Array[EntityComponent]:
	return get_accessory_one_entity_components() + get_accessory_two_entity_components()

func get_all_components()->Array[EntityComponent]:
	return get_substance_entity_components() + get_accessory_one_entity_components() + get_accessory_two_entity_components()

#endregion
