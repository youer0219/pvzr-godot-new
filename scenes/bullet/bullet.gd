extends RigidBody2D
class_name Bullet


@export var direction:Vector2 = Vector2.RIGHT
@export var speed:float = 100.0

@export var move_strategy:BulletMoveStrategy

func _physics_process(delta: float) -> void:
	move_strategy.execute_strategy(delta,self)

## 碰到墙壁后销毁自身  
## 弹跳实现？
func _on_body_entered(_body: Node) -> void:
	## TODO:发射粒子
	queue_free()
