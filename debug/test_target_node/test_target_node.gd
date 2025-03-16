extends Node2D


@export var enable:bool = true

@export var should_print:bool = false

func _physics_process(_delta: float) -> void:
	if enable:
		global_position = get_global_mouse_position()
		if should_print:
			print("Target Node Global Pos: ",global_position)
