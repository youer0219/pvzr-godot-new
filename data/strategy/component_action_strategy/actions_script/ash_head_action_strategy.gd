# ash_head_action_strategy.gd
class_name AshHeadStrategy
extends ComponentActionStrategy

func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	# 等待1.25秒后脱离主体
	await component.get_tree().create_timer(1.25).timeout
	component.leave_out()
	component.phy_enable = true
	
	# 再等待1.25秒后结束
	await component.get_tree().create_timer(1.25).timeout
	component.queue_free()
