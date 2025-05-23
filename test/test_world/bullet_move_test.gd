extends CharacterBody2D

@export var target_pos:Vector2 = Vector2(1,1)
@export var grid_cell:Vector2 = Vector2(16,16)
@export var move_time:float = 1.0

@export_range(1,10,1.0) var bounce_times:int = 0

var init_speed:Vector2
var gravity:float

func _ready() -> void:
	move_ready()

func move_ready():
	init_speed.x = (target_pos.x * grid_cell.x) / move_time
	init_speed.y = -1 * 2 * (target_pos.y * grid_cell.y) / move_time
	gravity = 2 * (target_pos.y * grid_cell.y) / pow(move_time,2)
	
	velocity = init_speed

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision and bounce_times > 0.0:
		gravity = 0.0
		bounce_times -= 1
		velocity = velocity.bounce(collision.get_normal())
