# no_action_strategy.gd
class_name NoActionStrategy
extends ComponentActionStrategy


func execute(component: EntityComponent, _damage_data: DamageData) -> void:
	print(component.name + " NO ACTION")
