# ash_head_action_strategy.gd
class_name AshHeadStrategy
extends ComponentActionStrategy

var tween:Tween

func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	if tween:
		tween.kill()
	
	tween = component.create_tween()
	tween.tween_interval(2)
	#tween.tween_callback(component.leave_out) ## 感觉ash-head时并不需要脱离实体
	tween.tween_callback(
		func():
			component.is_ash = true
			component.phy_enable = true
	)
	tween.tween_interval(1.25)
	tween.tween_callback(component.queue_free)

func can_execute(component: EntityComponent,_damage_data: DamageData)->bool:
	return component.is_in_body and not component.is_ash
