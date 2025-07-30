extends GD_Buff
class_name ThrowComponentBuff

@export var throw_force:Vector2 = Vector2(80,-200)

func _on_buff_start(_container: GD_BuffContainer, runtime_buff: GD_RuntimeBuff) -> void:
	var component = runtime_buff.blackboard["component"] as EntityComponent
	var force = runtime_buff.buff.throw_force
	var damage_data = runtime_buff.blackboard["damage_data"]
	EntityComponentActions.throw_component(damage_data,component,force)

## TODO: 同帧添加的buff无法生效（name重复）
## 解决方法： name唯一化  //  使用堆叠，但这可能需要await a frame
