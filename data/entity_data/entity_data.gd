class_name EntityData
extends Resource


@export var name:String
@export var entity_component_datas:Array[EntityComponentData]
@export var entity_init_buffs:Array[GD_Buff]

func _to_string() -> String:
	return name
