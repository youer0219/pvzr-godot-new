class_name BottomMap
extends TextureRect

## 白天天空
# 蓝色
const BLUE_SKY = preload("res://scenes/map/bottom_map/skys/BlueSky.tres")
# 黄色
const YELLOW_SKY = preload("res://scenes/map/bottom_map/skys/YellowSky.tres")
## 黑夜天空
const NIGHT_SKY = preload("res://scenes/map/bottom_map/skys/NightSky.tres")
## 红色天空
const RED_SKY = preload("res://scenes/map/bottom_map/skys/RedSky.tres")
## 粉色天空
const PINK_SKY = preload("res://scenes/map/bottom_map/skys/PinkSky.tres")

enum SKY_TYPE {BLUE,YELLOW,NIGHT,RED,PINK}

@export var map_data:MapData:set = _set_map_data

var sky_dic:Dictionary = {
	SKY_TYPE.BLUE:BLUE_SKY,
	SKY_TYPE.YELLOW:YELLOW_SKY,
	SKY_TYPE.NIGHT:NIGHT_SKY,
	SKY_TYPE.RED:RED_SKY,
	SKY_TYPE.PINK:PINK_SKY
}

func _ready() -> void:
	assert(_is_daytime_sky_type_right(),"BottomMap的白天天空类型配置错误！使用了非白天的天空类型！")

func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	modulate = Color(1,1,1,1)
	
	if map_data.is_boss_level:
		_set_sky(SKY_TYPE.RED)
	elif map_data.is_night_time:
		_set_sky(SKY_TYPE.NIGHT)
		modulate = Color("adadad")
	## TODO: 目前不确定原版游戏中黑夜是否可以触发粉色天空，现在约定只在白天可以触发
	elif _can_be_pink_sky():
		_set_sky(SKY_TYPE.PINK)
	else:
		_set_sky(map_data.daytime_sky_type)

func _can_be_pink_sky():
	var random := randi() % MapData.PINK_SKY_PROBABILITY
	map_data.is_pink_sky = random == 0
	return map_data.is_pink_sky

func _set_sky(sky_type:SKY_TYPE):
	texture = sky_dic[sky_type]

func _is_daytime_sky_type_right()->bool:
	return map_data.daytime_sky_type != SKY_TYPE.NIGHT and map_data.daytime_sky_type != SKY_TYPE.RED and map_data.daytime_sky_type != SKY_TYPE.PINK
