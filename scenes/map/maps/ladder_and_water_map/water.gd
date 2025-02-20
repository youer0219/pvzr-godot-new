class_name Water
extends Area2D

const FRAME_NUM := 32

@onready var water_sprite: AnimatedSprite2D = $WaterSprite

## TODO:动画效果可能还需要调整，特别是分辨率/窗口调整后
@export var half_loop_time:float = 0.9
@export var move_distance:int = 1.75

var random_frame:int
var is_first_layer_water := false:set = _set_is_first_layer_water

func _ready() -> void:
	random_frame = randi() % FRAME_NUM ## 随机帧开始
	water_sprite.frame = random_frame

func set_water_in_day_time():
	water_sprite.play("day")
	water_sprite.frame = random_frame

func set_water_in_night_time():
	water_sprite.play("night")
	water_sprite.frame = random_frame

func _set_is_first_layer_water(value:bool):
	is_first_layer_water = value
	
	if not is_node_ready(): ## 非导出变量，必要性存疑
		await ready
	
	if is_first_layer_water:
		var tween := create_tween().set_loops()
		var curr_y = water_sprite.position.y
		tween.tween_property(water_sprite,"position:y",curr_y + move_distance, half_loop_time)
		tween.tween_property(water_sprite,"position:y",curr_y, half_loop_time)
