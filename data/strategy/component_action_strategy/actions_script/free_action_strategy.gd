class_name FreeActionStrategy
extends ComponentActionStrategy


func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	component.queue_free()
