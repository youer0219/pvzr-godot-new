extends RefCounted
class_name ZoomComponentActions


static func throw_component(damage_data:DamageData,component:EntityComponent,force:Vector2 = Vector2(80,-200)):
	component.is_in_body = false
	component.reparent(component.get_tree().current_scene)
	component.phy_enable = true
	
	var direction = damage_data.get_throw_direction()
	component.apply_impulse(Vector2(direction * force.x, force.y))
	
	var tween = component.create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(component.queue_free)
