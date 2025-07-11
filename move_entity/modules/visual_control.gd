extends RemoteTransform2D
class_name VisualControl


func _on_char_move_twice_jump()->void:
	var tween:Tween = create_tween()
	tween.tween_property(self,"rotation_degrees",360 * scale.x,0.25)
	tween.tween_callback(self.set_rotation.bind(0))


func _on_char_physics_process(delta:float,char_body:CharacterBody2D)->void:
	if char_body.velocity.x > 0:
		scale.x = 1
	elif char_body.velocity.x < 0:
		scale.x = -1
	
	## TODO:目前需要访问char-body的char-move拿数据，这不太好，未来可以尝试在char-body中存数据
	var rotation_degress = 15 * (char_body.velocity.x / char_body.char_move.char_move_data.lateral_speed)
	rotation_degrees = move_toward(rotation_degrees,rotation_degress,delta*200)
