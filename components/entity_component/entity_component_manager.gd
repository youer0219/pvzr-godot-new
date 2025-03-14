extends Node2D
class_name EntityComponentManager



@export var main_body_canvas_group:EntityComponentCanvasGroup

@export var main_body_component:EntityComponent

## 传递伤害。根据BUFF决定着色器的状态。
## 链接下层信号。处理实体受伤/死亡/半血等事件。
## 转发下层的leave-out信号，处理组件离开事件。

func _ready() -> void:
	main_body_component.entity_component_dead.connect(_on_entity_component_dead)


## 应用伤害的方法
func apply_damage(damage_data:DamageData):
	main_body_component.apply_damage(damage_data)

## 处理实体组件死亡信号的方法
## 根据造成死亡的伤害类型调用组件的各个方法
func _on_entity_component_dead(entity_component: EntityComponent, damage_data: DamageData):
	if entity_component.entity_component_data.component_type == EntityComponent.EntityComponentType.MAIN_BODY:
		_entity_dead(damage_data)

func _entity_dead(damage_data:DamageData):
	var main_body_entity_components := get_main_body_entity_components()
	main_body_entity_components.all(
		func(entity_component:EntityComponent):
			entity_component.entity_dead(damage_data)
			return true
	)

## 处理实体组件受伤信号的方法

## 处理实体脱离信号的方法

## 处理实体半血信号的方法（可能无用，因为小鬼或许会做成组件）


func get_main_body_entity_components()->Array[EntityComponent]:
	return main_body_canvas_group.get_entity_components()
