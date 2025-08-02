extends GD_Buff
class_name HeadComponentAttackBuff

## component连接僵尸的攻击信号，进行攻击
## 攻击行为：头向下移动（TODO:缺乏参考物）

func _on_buff_start(container: GD_BuffContainer,runtime_buff: GD_RuntimeBuff) -> void:
	var entity := container.get_parent() as MoveEntity
	entity.entity_attack.connect(_on_entity_attack.bind(entity))
	runtime_buff.blackboard["aaa"] = container

func _on_entity_attack(entity:MoveEntity):
	var component = entity.entity_component_manager.get_head_entity_component()
	var tween := component.create_tween()
	## TODO: entity.entity_dir 成为固定值了
	tween.tween_property(component,"position",Vector2(-3 * entity.entity_dir,3),0.4)
	tween.tween_callback(component.set_position.bind(Vector2.ZERO))
