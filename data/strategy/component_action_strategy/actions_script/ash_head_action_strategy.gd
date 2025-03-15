# ash_head_action_strategy.gd
class_name AshHeadStrategy
extends ComponentActionStrategy

func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	var tween := component.create_tween()
	tween.tween_interval(2)
	tween.tween_callback(component.leave_out)
	tween.tween_callback(
		func():
			component.phy_enable = true
	)
	tween.tween_interval(1.25)
	tween.tween_callback(component.queue_free)
