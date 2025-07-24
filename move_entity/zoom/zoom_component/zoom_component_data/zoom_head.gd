extends ZoomComponentData
class_name ZoomHead


## 单独组件死亡结果
func _on_component_dead(damage_data:DamageData,component:ZoomComponent,):
	ZoomComponentActions.throw_component(damage_data,component,Vector2(80,-200))
