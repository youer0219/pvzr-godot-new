extends Node2D
class_name ZoomComponentManager

signal entity_dead(damage_data:DamageData)

const ENTITY_COMPONENT = preload("uid://d27ql2svxqnsf")

@export var entity_data:EntityData:set = _set_entity_data

@export var substance_canvas_group:ZoomComponentCanvasGroup
@export var accessory_one_entity_component:ZoomComponentCanvasGroup
@export var accessory_two_entity_component:ZoomComponentCanvasGroup

var last_global_position:Vector2

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
		_component_damage_apply(damage_data,head_component)
		if head_component.curr_hp <= 0:
			_on_entity_dead(damage_data)
		else:
			_on_entity_damaged(damage_data)
	else:
		_on_entity_dead(damage_data)

func _component_damage_apply(damage_data:DamageData,component:ZoomComponent):
	var hp := component.curr_hp
	component.curr_hp -= damage_data.damage
	damage_data.damage -= hp
	if component.curr_hp <= 0:
		damage_data.context["dead_components"].append(component)
	else:
		damage_data.context["damaged_components"].append(component)

func add_entity_components(zoom_component_datas:Array[ZoomComponentData]):
	for zoom_component_data:ZoomComponentData in zoom_component_datas:
		add_entity_component(zoom_component_data)

func add_entity_component(zoom_component_data:ZoomComponentData):
	var new_zoom_component = ENTITY_COMPONENT.instantiate() as ZoomComponent
	new_zoom_component.zoom_component_data = zoom_component_data
	
	match zoom_component_data.component_type:
		ZoomComponent.EntityComponentType.HEAD:
			substance_canvas_group.add_child(new_zoom_component)
		ZoomComponent.EntityComponentType.BODY:
			substance_canvas_group.add_child(new_zoom_component)
		ZoomComponent.EntityComponentType.ACCESSORY_TIER_1:
			accessory_one_entity_component.add_child(new_zoom_component)
		ZoomComponent.EntityComponentType.ACCESSORY_TIER_2:
			accessory_two_entity_component.add_child(new_zoom_component)
	
	new_zoom_component._on_add_zoom_component(self,new_zoom_component)

func clear_entity_components():
	substance_canvas_group.clear_entity_components()
	accessory_one_entity_component.clear_entity_components()
	accessory_two_entity_component.clear_entity_components()

func _set_entity_data(value:EntityData):
	entity_data = value
	
	if not is_node_ready():
		await ready
	
	clear_entity_components()
	add_entity_components(entity_data.entity_component_datas)


#region 事件信号处理
## 处理实体组件死亡信号的方法
## 根据造成死亡的伤害类型调用组件的各个方法

func _on_entity_dead(damage_data:DamageData):
	## 分为灰烬类和非灰烬类不同处理
	## 目前只关心非灰烬类
	
	## TODO:目前是调用所有的组件的eead回调，但这是否必要需要研究
	for component in get_all_components():
		component._on_zoom_common_dead(damage_data)
	
	entity_dead.emit(damage_data)

func _on_entity_damaged(damage_data:DamageData):
	## 二类  一类和本体
	var dead_components = damage_data.context["dead_components"]
	for component:ZoomComponent in dead_components:
		component._on_component_dead(damage_data)
	
	var damaged_components = damage_data.context["damaged_components"] as Array
	if damaged_components.any(
		func(component:ZoomComponent):
			return component.get_zoom_component_type() == ZoomComponent.EntityComponentType.ACCESSORY_TIER_2
	):
		accessory_two_entity_component.blink()
	else:
		accessory_one_entity_component.blink()
		substance_canvas_group.blink()

#endregion

#region 获取某类/所有组件的方法

func get_head_entity_component()->ZoomComponent:
	for component in get_substance_entity_components():
		if component.get_zoom_component_type() == ZoomComponent.EntityComponentType.HEAD:
			return component
	return null

func get_substance_entity_components()->Array[ZoomComponent]:
	return substance_canvas_group.get_entity_components()

func get_accessory_one_entity_components()->Array[ZoomComponent]:
	return accessory_one_entity_component.get_entity_components()

func get_accessory_two_entity_components()->Array[ZoomComponent]:
	return accessory_two_entity_component.get_entity_components()

func get_accessory_entity_components()->Array[ZoomComponent]:
	return get_accessory_one_entity_components() + get_accessory_two_entity_components()

func get_all_components()->Array[ZoomComponent]:
	return get_substance_entity_components() + get_accessory_one_entity_components() + get_accessory_two_entity_components()

#endregion
