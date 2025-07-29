# ash_body_action_strategy.gd
class_name AshBodyStrategy
extends ComponentActionStrategy

var tween:Tween

func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	if tween:
		tween.kill()
	
	# 创建溶解动画
	tween = component.create_tween()
	tween.tween_interval(2)
	tween.tween_method(
		func(value: float):
			component.is_ash = true 
			component.material.set_shader_parameter("dissolve_amount", value),
		0.0, 
		1.0, 
		1.0,
	)
	tween.tween_callback(component.queue_free)

func can_execute(component: EntityComponent,_damage_data: DamageData)->bool:
	return component.is_in_body and not component.is_ash
