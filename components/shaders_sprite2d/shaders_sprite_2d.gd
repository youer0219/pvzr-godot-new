@tool
extends Node2D

const SHADER_SPRITE_2D = preload("res://components/shaders_sprite2d/shader_sprite2d.tscn")

@export var texture:Texture2D:
	set(value):
		texture = value
		update_configuration_warnings()
@export var shaders_dir:Dictionary[StringName,Material]:
	set(value):
		shaders_dir = value
		update_configuration_warnings()

func _ready() -> void:
	if not Engine.is_editor_hint():
		generate()

func clear():
	for child in get_children():
		if child.is_class("Sprite2D"):
			child.queue_free()

func generate():
	clear()
	
	if texture == null:
		return
	
	var last_shader_sprite_2d:ShaderSprite2D = null
	var sprite2d_array:Array[Sprite2D] = []
	var texture_size:Vector2 = texture.get_size()
	
	for key in shaders_dir.keys():
		
		var new_shader_sprite_2d = SHADER_SPRITE_2D.instantiate() as ShaderSprite2D
		new_shader_sprite_2d.sprite_materal = shaders_dir[key]
		new_shader_sprite_2d.texture_size = texture_size
		sprite2d_array.append(new_shader_sprite_2d)
		
		if last_shader_sprite_2d == null:
			self.add_child(new_shader_sprite_2d)
		else:
			last_shader_sprite_2d.add_sprite_2d_node_child(new_shader_sprite_2d)
		
		last_shader_sprite_2d = new_shader_sprite_2d
	
	var sprite_2d:Sprite2D = Sprite2D.new()
	sprite_2d.texture = texture
	sprite2d_array.append(sprite_2d)
	
	if last_shader_sprite_2d == null:
		self.add_child(sprite_2d)
	else:
		last_shader_sprite_2d.add_sprite_2d_node_child(sprite_2d)
	
	for index in sprite2d_array.size():
		if index == 0:
			continue
		var index_sprite_2d:Sprite2D = sprite2d_array[index]
		index_sprite_2d.position = texture_size / 2.0
		
		if index_sprite_2d.texture is ViewportTexture:
			print("sprite_2d.texture.viewport_path: ",index_sprite_2d.texture.viewport_path)

func _get_configuration_warnings():
	var warnings = []
	
	if shaders_dir.size() <= 1:
		## 不建议在没有或只有一个shader的情况下使用该节点
		warnings.append("It is not recommended to use this node when there is no shader or only one shader.")
	
	var shader_materals := shaders_dir.values()
	for shader_materal in shader_materals:
		if not (shader_materal.is_class("ShaderMaterial") or shader_materal.is_class("CanvasItemMaterial")):
			## 请保证字典中的材质为ShaderMaterial或CanvasItemMaterial类型
			warnings.append("Please ensure that the materials in the dictionary are of the ShaderMaterial or CanvasItemMaterial type.")
			break
	
	if texture == null and shaders_dir.size() > 0:
		## 没有图像，shader资源无法生效
		warnings.append("Without an image, the shader resource will not take effect.")
	
	return warnings
