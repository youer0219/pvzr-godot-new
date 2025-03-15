extends Node2D
class_name EntityComponentManager

signal entity_component_leave_out(entity_component:EntityComponent)

@export var main_body_canvas_group:EntityComponentCanvasGroup
@export var accessory_one_entity_component:EntityComponentCanvasGroup
@export var main_body_component:EntityComponent

## 传递伤害。根据BUFF决定着色器的状态。
## 链接下层信号。处理实体受伤/死亡/半血等事件。
## 转发下层的leave-out信号，处理组件离开事件。

func _ready() -> void:
	main_body_component.entity_dead.connect(_on_entity_dead)
	main_body_component.entity_component_damaged.connect(_on_entity_component_damaged)
	
	for entity_component:EntityComponent in get_accessory_one_entity_components():
		entity_component.entity_component_damaged.connect(_on_entity_component_damaged)
	
	for entity_component:EntityComponent in get_all_components():
		entity_component.entity_component_leave_out.connect(_on_entity_component_leave_out)


## 应用伤害的方法
func apply_damage(damage_data:DamageData):
	## 因为资源传递的是引用，所以不需要返回一个资源回来了
	for entity_component in get_accessory_one_entity_components():
		entity_component.apply_damage(damage_data)
		if damage_data.damage < 0: ## 不等于0，这样为0时依然可以传递伤害，触发闪烁
			return
	
	if main_body_component != null:
		main_body_component.apply_damage(damage_data)
	else:
		_on_entity_dead(damage_data)

## 处理实体组件死亡信号的方法
## 根据造成死亡的伤害类型调用组件的各个方法

func _on_entity_dead(damage_data:DamageData):
	## 实体死亡后本体组件的引用直接设为空，避免出错
	main_body_component = null
	
	get_all_components().all(
		func(entity_component:EntityComponent):
			entity_component.on_entity_dead(damage_data)
			return true
	)

## 处理实体组件受伤信号的方法
func _on_entity_component_damaged(entity_component: EntityComponent):
	if entity_component.get_entity_component_type() == EntityComponent.EntityComponentType.ACCESSORY_TIER_2:
		pass
	else:
		main_body_canvas_group.blink()
		accessory_one_entity_component.blink()

## 处理实体脱离信号的方法
func _on_entity_component_leave_out(entity_component:EntityComponent):
	entity_component_leave_out.emit(entity_component)

## 处理实体半血信号的方法(暂时没有好的实现思路，不管)

func get_main_body_entity_components()->Array[EntityComponent]:
	return main_body_canvas_group.get_entity_components()

func get_accessory_one_entity_components()->Array[EntityComponent]:
	return accessory_one_entity_component.get_entity_components()

func get_all_components()->Array[EntityComponent]:
	return get_main_body_entity_components() + get_accessory_one_entity_components()
