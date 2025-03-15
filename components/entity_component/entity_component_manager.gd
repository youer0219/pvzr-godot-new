extends Node2D
class_name EntityComponentManager



@export var main_body_canvas_group:EntityComponentCanvasGroup

@export var main_body_component:EntityComponent

## 传递伤害。根据BUFF决定着色器的状态。
## 链接下层信号。处理实体受伤/死亡/半血等事件。
## 转发下层的leave-out信号，处理组件离开事件。

func _ready() -> void:
	main_body_component.entity_dead.connect(_on_entity_dead)
	main_body_component.entity_component_damaged.connect(_on_entity_component_damaged)


## 应用伤害的方法
func apply_damage(damage_data:DamageData):
	
	if main_body_component != null:
		main_body_component.apply_damage(damage_data)
	else:
		_on_entity_dead(damage_data)

## 处理实体组件死亡信号的方法
## 根据造成死亡的伤害类型调用组件的各个方法

func _on_entity_dead(damage_data:DamageData):
	## 实体死亡后本体组件的引用直接设为空，避免出错
	main_body_component = null
	
	var main_body_entity_components := get_main_body_entity_components()
	main_body_entity_components.all(
		func(entity_component:EntityComponent):
			entity_component._on_entity_dead(damage_data)
			return true
	)

## 处理实体组件受伤信号的方法
func _on_entity_component_damaged(entity_component: EntityComponent):
	if entity_component.get_entity_component_type() == EntityComponent.EntityComponentType.ACCESSORY_TIER_2:
		pass
	else:
		main_body_canvas_group.blink()

## 处理实体脱离信号的方法


## 处理实体半血信号的方法(暂时没有好的实现思路，不管)


func get_main_body_entity_components()->Array[EntityComponent]:
	return main_body_canvas_group.get_entity_components()
