class_name Map
extends Node2D

enum InternalMapGenerationType {
	INTERNAL_FIXED, ## 内部地图固定
	INTERNAL_MATCH_EXTERNAL_SCENE, ## 内部地图与外部地图场景一致
	INTERNAL_MATCH_EXTERNAL_SEED   ## 内部地图与外部地图种子一致
}

@export var map_data:MapData

@onready var ladder_and_water_map: LadderAndWaterMap = %LadderAndWaterMap
@onready var inner_canvas_group: CanvasGroup = %InnerCanvasGroup
@onready var ladder_and_water_canvas_group: CanvasGroup = %LadderAndWaterCanvasGroup
@onready var outer_canvas_group: CanvasGroup = %OuterCanvasGroup

var outer_map:TileMapLayer
var inner_map:TileMapLayer

func _ready() -> void:
	_generation_front_map()
	pass

func _on_outer_map_changed():
	ladder_and_water_map.used_cells = outer_map.get_used_cells()

func _generation_front_map():
	_clear_front_map()
	
	match map_data.inner_map_gen_type:
		InternalMapGenerationType.INTERNAL_FIXED:
			outer_map = map_data.outer_map_scene.instantiate() as TileMapLayer
			outer_canvas_group.add_child(outer_map)
			assert(map_data.inner_map_scene,"地图类型为固定内部场景，但没有配置相关场景！")
			inner_map = map_data.inner_map_scene.instantiate() as TileMapLayer
			inner_canvas_group.add_child(inner_map)
		InternalMapGenerationType.INTERNAL_MATCH_EXTERNAL_SCENE:
			print("未实现相关操作！")
			pass
		InternalMapGenerationType.INTERNAL_MATCH_EXTERNAL_SEED:
			print("未实现相关操作！")
			pass
	
	outer_map.changed.connect(_on_outer_map_changed)
	_on_outer_map_changed()
	
	ladder_and_water_map.create_water_layer()


## TODO:研究一下ladder怎么处理！！
## 大楼等随机地形需要随机生成梯子，至少要把梯子cells传递出来
## 以及是否要生成/删除水层？？

func _clear_front_map():
	for child in inner_canvas_group.get_children():
		child.queue_free()
	for child in outer_canvas_group.get_children():
		child.queue_free()

	pass
