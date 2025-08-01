extends GD_Buff
class_name HeadComponentAttackBuff

## component连接僵尸的攻击信号，进行攻击
## 攻击行为：头向下移动（TODO:缺乏参考物）

func _on_buff_start(container: GD_BuffContainer,runtime_buff: GD_RuntimeBuff) -> void:
	var entity := container.get_parent() as MoveEntity
	entity.entity_attack.connect(_on_entity_attack.bind(entity,runtime_buff))
	print("entity： ",entity.name ," runtime_buff: ",runtime_buff.get_instance_id())

func _on_entity_attack(entity:MoveEntity,runtime_buff:GD_RuntimeBuff):
	var component = runtime_buff.blackboard["component"] as EntityComponent
	var tween := component.create_tween()
	tween.tween_property(component,"position",Vector2(3*entity.entity_dir,3),0.4)
	tween.tween_callback(component.set_position.bind(Vector2.ZERO))
	print("entity： ",entity.name ," component: ",component.name," runtime_buff: ",runtime_buff.get_instance_id())


## TODO: COMMON-ZOOM发出的信号被TEST-ZOOM执行了，component不对，runtime-buff也不对
## 原因未知
