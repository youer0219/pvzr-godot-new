class_name MapData
extends Resource

@export var map_name:String

@export var daytime_sky_type:BottomMap.SKY_TYPE = BottomMap.SKY_TYPE.BLUE

@export var is_auto_scroll:bool
@export var auto_scroll_speed:int = 300

@export_range(0,15) var sunny_water_hight:int = 0
@export_range(0,15) var rain_water_hight:int = 0
## TODO: 雨天似乎会额外限制相机位置，避免看到过低的方块
