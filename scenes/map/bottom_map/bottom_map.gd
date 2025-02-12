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

## 注意不要选择非白天的天空类型！不要选择粉色这类彩蛋类型！
@export var daytime_sky_type:SKY_TYPE = SKY_TYPE.BLUE
@export var level_data:LevelData :set = _set_level_data

var sky_dic:Dictionary = {
	SKY_TYPE.BLUE:BLUE_SKY,
	SKY_TYPE.YELLOW:YELLOW_SKY,
	SKY_TYPE.NIGHT:NIGHT_SKY,
	SKY_TYPE.RED:RED_SKY,
	SKY_TYPE.PINK:PINK_SKY
}

func _ready() -> void:
	assert(_is_daytime_sky_type_right(),"BottomMap的白天天空类型配置错误！使用了非白天的天空类型！")

func _set_level_data(value:LevelData):
	level_data = value
	
	if not is_node_ready():
		await ready
	
	if level_data.is_boss_level():
		_set_sky(SKY_TYPE.RED)
	elif level_data.is_night_time():
		_set_sky(SKY_TYPE.NIGHT)
	## TODO: 目前不确定原版游戏中黑夜是否可以触发粉色天空，现在约定只在白天可以触发
	elif level_data.can_be_pink_sky():
		_set_sky(SKY_TYPE.PINK)
	elif level_data.is_day_time():
		_set_sky(daytime_sky_type)
	else:
		push_warning("BottomMap未根据LevelData设置天空类型，请检查逻辑是否正确")

func _set_sky(sky_type:SKY_TYPE):
	texture = sky_dic[sky_type]

func _is_daytime_sky_type_right()->bool:
	return daytime_sky_type != SKY_TYPE.NIGHT and daytime_sky_type != SKY_TYPE.RED and daytime_sky_type != SKY_TYPE.PINK
