extends Node
class_name EntityPathFinder

@export var entity:Entity

var curr_map_path_finder:MapPathFinder:
	get:
		return GlobalData.get_data(MapPathFinder.MAP_PATH_FINDER_KEY,null)

## 获取MAP路径
## 需要：对象全局位置
func get_map_path_to_global_pos(global_pos:Vector2)->Array[Vector2i]:
	var map_path:Array[Vector2i] = []
	
	var entity_cell := global_pos_to_map_cell(entity.global_position)
	var global_pos_cell := global_pos_to_map_cell(global_pos)
	
	if curr_map_path_finder != null:
		map_path = curr_map_path_finder.get_id_path(entity_cell,global_pos_cell)
	
	return map_path

## 获取全局坐标对应的MAP位置
func global_pos_to_map_cell(global_pos:Vector2)->Vector2i:
	if curr_map_path_finder != null:
		return curr_map_path_finder.global_pos_to_map_cell(global_pos)
	else:
		return curr_map_path_finder.VECTOR2I_NULL

## 路径处理逻辑  根据路径获取最新的行动方向
## 如果存在不同僵尸不同方法，可以采取策略模式（目前应该可以兼容）
#func get_entity_direction(map_path:Array[Vector2i])->Vector2i

## 判断是否需要更新路径（占位）
