extends Node

var dic = {}


func _ready() -> void:
	dic["node"] = self
	var new_dic = dic
	print("new_dic node: ",new_dic["node"])
	var duplicate_false_dic = dic.duplicate()
	print("duplicate_false_dic node: ",duplicate_false_dic["node"])
	var duplicate_true_dic = dic.duplicate(true)
	print("duplicate_true_dic node: ",duplicate_true_dic["node"])
	var dic_02 = {
		"asdasda":1212,
		"nod111e":10,
	}
	dic.merge(dic_02)
	print(dic)
