class_name Map
extends Node2D

@export var map_data:MapData

@onready var ladder_and_wter_map: LadderAndWaterMap = %LadderAndWterMap
@onready var outer_map: TileMapLayer = %OuterMap

func _ready() -> void:
	outer_map.changed.connect(_on_outer_map_changed)
	_on_outer_map_changed()
	
	ladder_and_wter_map.create_water_layer()


func _on_outer_map_changed():
	ladder_and_wter_map.used_cells = outer_map.get_used_cells()
