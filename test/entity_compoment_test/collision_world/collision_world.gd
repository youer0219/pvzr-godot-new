extends Node2D

@onready var entity: RigidBody2D = $Entity
@onready var map: Map = $Map


#func _ready() -> void:
	#
	#await get_tree().create_timer(1.5).timeout
	#
	#var damage_data:DamageData = preload("res://data/damage_data/test_damage_data.tres").duplicate()
	#damage_data.damage_type = DamageData.DamageType.EXPLOSIVE_DAMAGE
	#for i in range(10):
		#damage_data.damage = 5.0
		#await get_tree().create_timer(0.4).timeout
		#entity.apply_damage(damage_data)


func _on_timer_timeout() -> void:
	var new_path := map.map_path_finder.get_global_path(entity.global_position,get_global_mouse_position())
	print("new_path: ",new_path)
	PathShowTool.draw_path(self,new_path,Color.AZURE,5.0)
