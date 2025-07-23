# no_action_strategy.gd
class_name NoActionStrategy
extends ComponentActionStrategy


func execute(component: ZoomComponent, _damage_data: DamageData) -> void:
	print(component.name + " NO ACTION")
