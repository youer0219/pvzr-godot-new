class_name FreeActionStrategy
extends ComponentActionStrategy


func execute(component: ZoomComponent, _damage_data: DamageData) -> void:
	component.queue_free()
