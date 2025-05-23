extends CharacterBody2D
class_name Bullet

@export var direction:Vector2 = Vector2.RIGHT
@export var speed:float = 100.0
@export var move_strategy:BulletMoveStrategy
@export_range(0,10,1.0) var bounce_times:int = 0

func _ready() -> void:
	move_strategy.ready(self)

func _physics_process(delta: float) -> void:
	move_strategy.physics_process(delta,self)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if bounce_times > 0:
			bounce_times -= 1
			move_strategy.enable = false
			velocity = velocity.bounce(collision.get_normal())
		else:
			queue_free()
