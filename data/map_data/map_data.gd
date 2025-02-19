class_name MapData
extends Resource

## 只是记录家院地图中需要额外删除的梯子的位置。目前不使用这个数据。
const HOME_EXTRA_LADDER_CELLS = [Vector2i(25,12)]

const MAP_CELL_SIZE := Vector2(32,32)
const MAP_SIZE := Vector2(72,24)
const PINK_SKY_PROBABILITY := 100

@export_group("固定数据")
@export var map_name:String
@export var daytime_sky_type:BottomMap.SKY_TYPE = BottomMap.SKY_TYPE.BLUE
@export var is_auto_scroll:bool
@export var auto_scroll_speed:int = 300
@export_range(0,15) var sunny_water_hight:int = 0
@export_range(0,15) var rain_water_hight:int = 0
@export var extra_delete_ladder_cells:Array[Vector2i]
## TODO: 雨天似乎会额外限制相机位置，避免看到过低的方块


@export_group("可变数据")
@export var is_raining:bool
## TODO:这里不确定是否应该直接给出sky类型，可以等map-data完善后整理需求再决定天空类型的判断逻辑应该放在哪里。
@export var is_night_time:bool
@export var is_boss_level:bool
@export var is_pink_sky:bool
@export var parallax_map_type:ParallaxMap.ParallaxMapType

## TODO:我希望一个map-data加一个基本的map场景就可以代表map
## 这需要更多的对场景的导出变量和相关场景的实现
