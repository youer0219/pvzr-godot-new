class_name ShaderSprite2D
extends Sprite2D

@onready var sub_viewport: SubViewport = $SubViewport

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "ShaderMaterial,CanvasItemMaterial") var sprite_materal:Material:set = _set_sprite_materal

var texture_size:Vector2:set = _set_texture_size

func _set_sprite_materal(value:Material):
	assert(value.is_class("ShaderMaterial") or value.is_class("CanvasItemMaterial"),"错误的sprite材质配置")
	sprite_materal = value
	
	material = sprite_materal

func _set_texture_size(value:Vector2):
	texture_size = value
	
	if not is_node_ready():
		await ready
	
	sub_viewport.size = texture_size


func add_sprite_2d_node_child(sprite_2d:Sprite2D):
	sub_viewport.add_child(sprite_2d)
