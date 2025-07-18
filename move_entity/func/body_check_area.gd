extends Area2D
class_name BodyCheckArea

var bodys:Array = []

func _on_body_entered(body: Node2D) -> void:
	bodys.append(body)

func _on_body_exited(body: Node2D) -> void:
	bodys.erase(body)
