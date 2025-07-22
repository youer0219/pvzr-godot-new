extends Node
class_name EntityPathFinder

const MAP_PATH_BLACKGROUND_KEY := "MAP_PATH"
const MAP_PATH_DEFAULT_VAR :Array[Vector2i] = []
const DIRECTION_BLACKGROUND_KEY := "DIRECTION"
const DIRECTION_DEFAULT_VAR := Vector2.ZERO

@export var entity:MoveEntity

var curr_map_path_finder:MapPathFinder:
	get:
		return GlobalData.get_data(MapPathFinder.MAP_PATH_FINDER_KEY,null)

## 获取MAP路径
## 需要：对象全局位置
func get_map_path_to_global_pos(global_pos:Vector2)->Array[Vector2]:
	var map_path:Array[Vector2] = []
	if curr_map_path_finder == null:
		return map_path
	
	map_path = curr_map_path_finder.get_global_path(entity.global_position,global_pos,true)
	
	return map_path
