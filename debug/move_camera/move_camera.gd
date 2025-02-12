extends Camera2D

@export var enable:bool = false
@export var speed:int = 5

func _process(delta: float) -> void:
	if not enable:
		return
	
	if Input.is_action_pressed("camera_move_down"):
		position.y += speed
	if Input.is_action_pressed("camera_move_up"):
		position.y -= speed
	if Input.is_action_pressed("camera_move_left"):
		position.x -= speed
	if Input.is_action_pressed("camera_move_right"):
		position.x += speed
