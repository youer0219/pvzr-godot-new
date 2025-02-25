class_name MountainMap
extends RandomMap

@onready var heightmap_generator_2d: HeightmapGenerator2D = $HeightmapGenerator2D

func generate_map(random_seed:int,type:RandomMap.Type):
	clear()
	
	if not is_node_ready():
		await ready
	
	heightmap_generator_2d.seed = random_seed
	match type:
		RandomMap.Type.OUTER:
			collision_enabled = true
		RandomMap.Type.INNER:
			collision_enabled = false
	
	heightmap_generator_2d.generate()

func get_random_ladder_cells()->Array[Vector2i]:
	return []
