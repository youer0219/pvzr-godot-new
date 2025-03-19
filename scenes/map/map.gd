class_name Map
extends Node2D

enum MapGenerationType {
	FIXED, ## 固定地图
	RANDOM ## 随机地图。内外部种子一致。
}

@export var map_data:MapData:set = _set_map_data

@onready var front_map: FrontMap = %FrontMap
@onready var bottom_map: BottomMap = %BottomMap
@onready var parallax_map: ParallaxMap = %ParallaxMap
@onready var map_path_finder: MapPathFinder = %MapPathFinder

## TODO：$MapBorderCollisions 应该会阻挡僵尸和戴夫等实体，不应该与子弹等碰撞。目前设置layer为world无法满足后者。
## 但还没有实现子弹碰撞相关的设置，所以暂时这样写。
## TODO:在地图最上面没有针对实体的碰撞，但有一个会弹回气球状态的僵尸的碰撞体。目前无思路。

func _ready() -> void:
	front_map.front_map_generate_finished.connect(map_path_finder.update_points)

func generate_ladder_by_cell(cell:Vector2i):
	front_map.generate_ladder_by_cell(cell)

func deleta_ladder_by_cell(cell:Vector2i):
	front_map.deleta_ladder_by_cell(cell)

func generate_snow_by_cell(cell:Vector2i):
	front_map.generate_snow_by_cell(cell)

func get_top_water_line()->float:
	var water_height := map_data.water_hight
	return (MapData.MAP_SIZE.y - water_height ) * MapData.MAP_CELL_SIZE.y


func _set_map_data(value:MapData):
	map_data = value
	
	if not is_node_ready():
		await ready
	
	map_path_finder.top_water_cell_y = int(map_data.MAP_SIZE.y - map_data.water_hight)
	
	bottom_map.map_data = map_data
	parallax_map.map_data = map_data
	front_map.map_data = map_data
