@tool
extends BTAction
## 自定义任务类

var agent_node:Entity

@export var update_frequency:int = 3

# 显示自定义名称（需要 @tool）。
func _generate_name() -> String:
	return "Entity update map-path & direction"

# 每次此任务被 tick（即执行）时调用。
func _tick(_delta: float) -> Status:
	var map_path:Array[Vector2i] = []
	var direction:Vector2 = Vector2.ZERO
	## 更新路径(目前写死目标为全局鼠标位置)  每 update_frequency 帧执行一次
	if agent_node.get_tree().get_frame() % update_frequency == 0:
		map_path = agent_node.entity_path_finder.get_map_path_to_global_pos(agent_node.get_global_mouse_position())
		blackboard.set_var(EntityPathFinder.MAP_PATH_BLACKGROUND_KEY,map_path)
		direction = agent_node.entity_path_finder.get_entity_direction(map_path)
		blackboard.set_var(EntityPathFinder.DIRECTION_BLACKGROUND_KEY,direction)
		
		blackboard.print_state()
	
	## TODO: 是否应该继续执行下去，把根据方向移动的代码也写在这里
	
	return SUCCESS

# 初始化时调用一次。
func _setup() -> void:
	if not agent is Entity:
		push_error("这是专属于代理为entity的任务！")
	agent_node = agent
	
	if not blackboard.has_var(EntityPathFinder.MAP_PATH_BLACKGROUND_KEY):
		blackboard.set_var(EntityPathFinder.MAP_PATH_BLACKGROUND_KEY,EntityPathFinder.MAP_PATH_DEFAULT_VAR)
	
	if not blackboard.has_var(EntityPathFinder.DIRECTION_BLACKGROUND_KEY):
		blackboard.set_var(EntityPathFinder.DIRECTION_BLACKGROUND_KEY,EntityPathFinder.DIRECTION_DEFAULT_VAR)


# 每次进入此任务时调用。
func _enter() -> void:
	pass

# 每次退出此任务时调用。
func _exit() -> void:
	pass
