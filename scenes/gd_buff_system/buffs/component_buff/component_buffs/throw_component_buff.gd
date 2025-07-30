extends ComponentBuff
class_name ThrowComponentBuff


@export var throw_force:Vector2 = Vector2(80,-200)
@export var signal_names:Array[String]

func _on_buff_start(_container: GD_BuffContainer, runtime_buff: GD_RuntimeBuff) -> void:
	_on_add_component(runtime_buff)

func _on_stack_layer_change(_container: GD_BuffContainer,_runtime_buff: GD_RuntimeBuff,new_runtime_buff: GD_RuntimeBuff,_is_over:bool):
	_on_add_component(new_runtime_buff)

func _on_add_component(runtime_buff:GD_RuntimeBuff)->void:
	var new_component = runtime_buff.blackboard[COMPONENT] as EntityComponent
	var force = runtime_buff.buff.throw_force
	for signal_name in signal_names:
		new_component.connect(signal_name,throw_component.bind(force))

func throw_component(component:EntityComponent,damage_data:DamageData,force:Vector2)->void:
	ZoomComponentActions.throw_component(damage_data,component,force)
