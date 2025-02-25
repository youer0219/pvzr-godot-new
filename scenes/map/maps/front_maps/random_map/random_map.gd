class_name RandomMap
extends TileMapLayer


enum Type {OUTER,INNER}

func get_random_ladder_cells()->Array[Vector2i]:
	push_error("这是抽象类。请不要直接调用该方法")
	return []

static func get_random_seed()->int:
	return randi()

func generate_map(seed:int,type:RandomMap.Type):
	push_error("这是抽象类。请不要直接调用该方法")
