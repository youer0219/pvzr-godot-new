extends RigidBody2D
class_name ZoomComponent

@onready var collision_shape: CollisionShape2D = $CollisionShape

## 当前生命值
#var curr_hp
## 状态
var phy_enable: bool = false:set = _set_phy_enable


func _set_phy_enable(value: bool) -> void:
	phy_enable = value
	
	freeze = not phy_enable
	collision_shape.set_deferred("disabled", not phy_enable)
