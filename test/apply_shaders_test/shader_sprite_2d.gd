extends Sprite2D
class_name ShaderSprite2D

@export var shader_sprite_resource:ShaderSpriteResource:set = _set_shader_sprite_resource


func _set_shader_sprite_resource(value:ShaderSpriteResource):
	shader_sprite_resource = value
	
	if not shader_sprite_resource.changed.is_connected(_update_shader_sprite):
		shader_sprite_resource.changed.connect(_update_shader_sprite)
	_update_shader_sprite()


func _update_shader_sprite():
	if shader_sprite_resource.enable:
		self.material = shader_sprite_resource.shader_mayerial
