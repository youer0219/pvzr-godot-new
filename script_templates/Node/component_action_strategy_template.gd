extends ComponentActionStrategy


func execute(_component: EntityComponent, _damage_data: DamageData) -> void:
	push_error("抽象方法需实现")
