class_name MapData
extends Resource

## 只是记录家院地图中需要额外删除的梯子的位置。目前不使用这个数据。
const HOME_EXTRA_LADDER_CELLS = [Vector2i(25,12)]

@export var map_name:String

@export var daytime_sky_type:BottomMap.SKY_TYPE = BottomMap.SKY_TYPE.BLUE

@export var is_auto_scroll:bool
@export var auto_scroll_speed:int = 300

@export_range(0,15) var sunny_water_hight:int = 0
@export_range(0,15) var rain_water_hight:int = 0
@export var extra_delete_ladder_cells:Array[Vector2i]
## TODO: 雨天似乎会额外限制相机位置，避免看到过低的方块

## TODO:一定程度上，我希望一个map-data加一个基本的map场景就可以代表map，但目前一些场景是固定的，需要指定scene才好
## 所以暂时不这样做
