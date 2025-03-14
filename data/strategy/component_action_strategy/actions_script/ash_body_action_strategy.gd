# ash_body_action_strategy.gd
class_name AshBodyStrategy
extends ComponentActionStrategy

func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	# 等待1.25秒后开始溶解
	await component.get_tree().create_timer(1.25).timeout
	
	# 创建溶解动画
	var tween = component.create_tween()
	tween.tween_method(
		func(value: float): 
			component.material.set_shader_parameter("dissolve_amount", value),
		0.0, 
		1.0, 
		1.0
	)
	tween.tween_callback(component.queue_free)
