extends ComponentActionStrategy


func execute(_component: ZoomComponent, _damage_data: DamageData) -> void:
	push_error("抽象方法需实现")
