extends Node2D
class_name ShadersSprite2D

const SHADER_SPRITE_2D = preload("res://test/apply_shaders_test/shader_sprite_2d.tscn")

@export var sprite_shaders:Array[ShaderSpriteResource]
@export var texture:Texture2D

var sprite_2d_array:Array[Sprite2D] = []


func initiate_shaders_sprite2d():
	if texture == null:
		return
	
	if sprite_shaders.size() == 0:
		return
	
	clear_shaders_sprite2d()
	
	var texture_center := texture.get_size() / 2
	var last_shader_sprite_2d:ShaderSprite2D = null
	var sprite_shaders_size := sprite_shaders.size()
	
	#for index in sprite_shaders_size:
		#
		#var new_shader_sprite:ShaderSprite2D = SHADER_SPRITE_2D.instantiate() as ShaderSprite2D
		#new_shader_sprite.position = texture_center
		#new_shader_sprite.shader_sprite_resource = sprite_shaders[index]
		#
		#if last_shader_sprite_2d == null:
			#self.add_child(new_shader_sprite)
		#else:
			#last_shader_sprite_2d.add_child(new_shader_sprite)
		#
		#last_shader_sprite_2d = new_shader_sprite
		#
		#if sprite_shaders_size - index != 1:
			#var subviewport = _get_subviewport()
			#last_shader_sprite_2d.add_child(subviewport)
			#var viewport_texture:ViewportTexture


func clear_shaders_sprite2d():
	for child in get_children():
		child.queue_free()
	
	sprite_2d_array = []

## 创建合适的viewport节点
func _get_subviewport()->SubViewport:
	if texture == null:
		return null
	
	var subviewport = SubViewport.new()
	subviewport.disable_3d = true
	subviewport.transparent_bg = true
	subviewport.size = texture.get_size()
	
	return null
