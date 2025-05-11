extends RigidBody2D
class_name Bullet


@export var direction:Vector2 = Vector2.RIGHT
@export var speed:float = 100.0


## 碰到墙壁后销毁自身  穿透通过调整碰撞层等方式实现
func _on_body_entered(body: Node) -> void:
	## TODO:发射粒子
	queue_free()
