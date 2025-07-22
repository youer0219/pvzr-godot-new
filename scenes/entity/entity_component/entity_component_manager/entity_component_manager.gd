extends Node2D
class_name EntityComponentManager

signal entity_component_leave_out(entity_component:EntityComponent)
signal entity_dead(damage_data:DamageData)

const ENTITY_COMPONENT = preload("res://scenes/entity/entity_component/entity_component.tscn")

@export var entity_data:EntityData:set = _set_entity_data

@export var main_body_canvas_group:EntityComponentCanvasGroup
@export var accessory_one_entity_component:EntityComponentCanvasGroup
@export var accessory_two_entity_component:EntityComponentCanvasGroup
@export var main_body_component:EntityComponent

var last_global_position:Vector2

func _physics_process(_delta: float) -> void:
	accessory_one_entity_component.global_position = last_global_position
	accessory_two_entity_component.global_position = last_global_position
	last_global_position = global_position

## 应用伤害的方法
func apply_damage(damage_data:DamageData):
	## 因为资源传递的是引用，所以不需要返回一个资源回来了
	pass


func add_entity_components(entity_component_datas:Array[EntityComponentData]):
	for entity_component_data:EntityComponentData in entity_component_datas:
		add_entity_component(entity_component_data)

func add_entity_component(entity_component_data:EntityComponentData):
	var new_entity_component = ENTITY_COMPONENT.instantiate() as EntityComponent
	new_entity_component.entity_component_data = entity_component_data
	
	match entity_component_data.component_type:
		EntityComponent.EntityComponentType.MAIN_BODY:
			## TODO:目前依赖数据中的指定，配置起来还是不安全。暂时这样吧。
			if entity_component_data.is_main_body:
				main_body_component = new_entity_component
			main_body_canvas_group.add_child(new_entity_component)
		EntityComponent.EntityComponentType.ACCESSORY_TIER_1:
			accessory_one_entity_component.add_child(new_entity_component)
		EntityComponent.EntityComponentType.ACCESSORY_TIER_2:
			accessory_two_entity_component.add_child(new_entity_component)

func clear_entity_components():
	main_body_canvas_group.clear_entity_components()
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
	## 实体死亡后本体组件的引用直接设为空，避免出错
	main_body_component = null
	
	get_all_components().all(
		func(entity_component:EntityComponent):
			#entity_component._on_entity_dead(damage_data)
			return true
	)
	
	entity_dead.emit(damage_data)

## 处理实体组件受伤信号的方法
func _on_entity_component_damaged(entity_component: EntityComponent):
	if entity_component.get_entity_component_type() == EntityComponent.EntityComponentType.ACCESSORY_TIER_2:
		accessory_two_entity_component.blink()
	else:
		main_body_canvas_group.blink()
		accessory_one_entity_component.blink()

## 处理实体脱离信号的方法
func _on_entity_component_leave_out(entity_component:EntityComponent):
	entity_component_leave_out.emit(entity_component)


#endregion

#region 获取某类/所有组件的方法

func get_main_body_entity_components()->Array[EntityComponent]:
	return main_body_canvas_group.get_entity_components()

func get_accessory_one_entity_components()->Array[EntityComponent]:
	return accessory_one_entity_component.get_entity_components()

func get_accessory_two_entity_components()->Array[EntityComponent]:
	return accessory_two_entity_component.get_entity_components()

func get_accessory_entity_components()->Array[EntityComponent]:
	return get_accessory_one_entity_components() + get_accessory_two_entity_components()

func get_all_components()->Array[EntityComponent]:
	return get_main_body_entity_components() + get_accessory_one_entity_components() + get_accessory_two_entity_components()

#endregion
