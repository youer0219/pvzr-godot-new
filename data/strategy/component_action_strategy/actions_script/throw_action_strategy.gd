# throw_action_strategy.gd
class_name ThrowActionStrategy
extends ComponentActionStrategy

@export var horizontal_force: float = 80.0
@export var vertical_force: float = -400.0

func execute(entity: ZoomComponent, damage_data: DamageData) -> void:
	entity.leave_out()
	entity.phy_enable = true
	
	var direction = damage_data.get_throw_direction()
	entity.apply_impulse(Vector2(direction * horizontal_force, vertical_force))
	
	var tween = entity.create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(entity.queue_free)
