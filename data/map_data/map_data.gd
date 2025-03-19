@tool
class_name MapData
extends Resource

## 只是记录家院地图中需要额外删除的梯子的位置。目前不使用这个数据。
const HOME_EXTRA_LADDER_CELLS = [Vector2i(25,12)]

const MAP_CELL_SIZE := Vector2(16,16)
const MAP_SIZE := Vector2(72,24)
const PINK_SKY_PROBABILITY := 100

const LADDER_SOURCE_ID := 1
const MAP_SCENE_SOURCE_ID := 2
const WATER_SCENE_ID := 1
const SNOW_SCENE_ID := 2

enum BACK_TYPE {
	GRESS, ## 草地背景+蓝色天空
	SAND,  ## 沙地背景+黄昏天空
	}

@export_group("Map配置数据")
@export var map_name:String
@export var back_type:BACK_TYPE = BACK_TYPE.GRESS: set = _set_back_type
@export var is_auto_scroll:bool
@export var auto_scroll_speed:int = 300
## TODO: 还不清楚山地的水的机制。是否随机高度以及目前山地的生成可能导致雨天没水！
@export_range(0,15) var sunny_water_hight:int = 0
@export_range(0,15) var rain_water_hight:int = 0
@export var extra_delete_ladder_cells_in_raining_day:Array[Vector2i]
@export var front_map_gen_type:FrontMap.FrontMapGenerationType:set = _set_map_gen_type
@export var outer_map_scene:PackedScene
@export var inner_map_scene:PackedScene
@export var ladder_map_scene:PackedScene
@export var decorative_map_scene:PackedScene
@export var random_map_scene:PackedScene

@export_group("可变数据")
@export var is_raining:bool
## TODO:这里不确定是否应该直接给出sky类型，可以等map-data完善后整理需求再决定天空类型的判断逻辑应该放在哪里。
@export var is_night_time:bool
@export var is_boss_level:bool
@export var is_pink_sky:bool

var water_hight:int = 0:
	get:
		return rain_water_hight if is_raining else sunny_water_hight
var daytime_sky_type:BottomMap.SKY_TYPE = BottomMap.SKY_TYPE.BLUE
var parallax_map_type:ParallaxMap.ParallaxMapType

func _set_back_type(value:BACK_TYPE):
	back_type = value
	match back_type:
		BACK_TYPE.GRESS:
			daytime_sky_type = BottomMap.SKY_TYPE.BLUE
			parallax_map_type = ParallaxMap.ParallaxMapType.GRESS
		BACK_TYPE.SAND:
			daytime_sky_type = BottomMap.SKY_TYPE.YELLOW
			parallax_map_type = ParallaxMap.ParallaxMapType.SAND

func _set_map_gen_type(value:FrontMap.FrontMapGenerationType):
	front_map_gen_type = value
	notify_property_list_changed()

func _validate_property(property:Dictionary):
	match front_map_gen_type:
		Map.MapGenerationType.FIXED:
			if property.name == "random_map_scene":
				property.usage = PROPERTY_USAGE_NONE
		Map.MapGenerationType.RANDOM:
			if property.name == "outer_map_scene" or property.name == "inner_map_scene" or property.name == "ladder_map_scene" or property.name == "decorative_map_scene":
				property.usage = PROPERTY_USAGE_NONE
