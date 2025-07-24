extends RefCounted
class_name ZoomComponentActions


static func throw_component(damage_data:DamageData,component:ZoomComponent,force:Vector2 = Vector2(80,-200)):
	component.is_in_body = false
	component.reparent(component.get_tree().current_scene)
	component.phy_enable = true
	
	var direction = damage_data.get_throw_direction()
	component.apply_impulse(Vector2(direction * force.x, force.y))
	
	var tween = component.create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(component.queue_free)

static func ash_fall(component: ZoomComponent, _damage_data: DamageData) -> Tween:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	var ash_tween := component.create_tween()
	
	ash_tween.tween_interval(2)
	ash_tween.tween_callback(component._set_phy_enable.bind(true))
	ash_tween.tween_interval(1.25)
	ash_tween.tween_callback(component.queue_free)
	
	return ash_tween

static func ash_free(component: ZoomComponent, _damage_data: DamageData) -> Tween:
	# 设置灰烬材质
	component.material.set_shader_parameter("use_replace_color", true)
	component.material.set_shader_parameter("replace_color", Color.BLACK)
	
	var tween := component.create_tween()
	
	# 创建溶解动画
	tween.tween_interval(2)
	tween.tween_method(
		func(value: float):
			component.material.set_shader_parameter("dissolve_amount", value),
		0.0, 
		1.0, 
		1.0,
	)
	tween.tween_callback(component.queue_free)
	
	return tween
