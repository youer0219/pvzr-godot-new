extends GD_Buff
class_name ThrowComponentBuff

@export var throw_force:Vector2 = Vector2(80,-200)

func _init() -> void:
	stack_type = STACK_TYPE.STACK

func _on_buff_awake(_container: GD_BuffContainer, runtime_buff: GD_RuntimeBuff) -> void:
	_throw_component(runtime_buff)

func _on_stack_layer_change(_container: GD_BuffContainer,runtime_buff: GD_RuntimeBuff,_new_runtime_buff: GD_RuntimeBuff,_is_over:bool):
	## 不考虑_is_over时，只要有新buff就会触发该方法，不需担心layer上限
	_throw_component(runtime_buff)

func _throw_component(runtime_buff:GD_RuntimeBuff)->void:
	var component = runtime_buff.blackboard["component"] as EntityComponent
	var force = runtime_buff.buff.throw_force
	var damage_data = runtime_buff.blackboard["damage_data"]
	EntityComponentActions.throw_component(damage_data,component,force)
