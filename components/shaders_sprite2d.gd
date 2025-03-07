@tool
class_name ShadersSprite2D
extends Sprite2D
## 使用方法：
## 在bottom_texture中添加图像；在shaders_dir中添加着色器名称与着色器材质资源
## 该节点在编辑器中也能实时显示效果。但目前存在因数据配置出错等问题导致图像不能正确显示的问题。
## 可以采取的策略是重新添加bottom_texture或shaders_dir以触发更新函数
## 这里允许创建CanvasItemMaterial类型的材质，但作者没有用过，所以没有测试……


@export var bottom_texture:Texture2D:
	set(value):
		bottom_texture = value
		generate()
		update_configuration_warnings()
@export var shaders_dir:Dictionary[StringName,Material]:
	set(value):
		shaders_dir = value
		generate()
		update_configuration_warnings()

var first_sub_viewport:SubViewport

func _ready() -> void:
	generate()


func clear():
	texture = null
	material = null
	if first_sub_viewport != null:
		first_sub_viewport.queue_free()
		first_sub_viewport = null

func set_shader_param_by_name(choose_material_name:StringName,param:StringName, value:Variant):
	var choose_material = get_material_by_name(choose_material_name) as ShaderMaterial
	if choose_material == null:
		return null
	choose_material.set_shader_parameter(param,value)

func get_material_by_name(choose_material_name:StringName)->Material:
	if not shaders_dir.has(choose_material_name):
		push_warning(name + " shaders_dir" + "not has "+ choose_material_name)
		return null
	return shaders_dir[choose_material_name]

func generate():
	clear()
	
	if bottom_texture == null:
		return
	
	var shaders_dir_size := shaders_dir.size()
	
	## 没有shader，返回
	if shaders_dir_size == 0:
		return
	
	var last_sprite_2d:Sprite2D = self
	var shaders_array:Array = shaders_dir.values()
	
	for shader in shaders_array:
		assert(shader.is_class("ShaderMaterial") or shader.is_class("CanvasItemMaterial"),"错误的sprite材质配置")
	
	if shaders_dir_size == 1:
		texture = bottom_texture
		material = shaders_array[0]
		return
	
	for index in shaders_dir_size:
		var new_material:Material = shaders_array[index]
		last_sprite_2d.material = new_material
		## 添加subviewport
		
		var new_subviewport:SubViewport = _get_subviewport()
		last_sprite_2d.add_child(new_subviewport)
		if first_sub_viewport == null:
			first_sub_viewport = new_subviewport
		
		## 给sprite2d添加viewport-texture
		last_sprite_2d.texture = new_subviewport.get_texture()
		
		## 添加新的sprite2d
		var new_sprite_2d:Sprite2D = Sprite2D.new()
		new_sprite_2d.position = bottom_texture.get_size() / 2.0
		new_subviewport.add_child(new_sprite_2d)
		last_sprite_2d = new_sprite_2d
	
	last_sprite_2d.texture = bottom_texture

## 内部方法。获取一个适配图像大小的禁用3D渲染的透明背景的SubViewport实例化节点。
func _get_subviewport()->SubViewport:
	var subviewport = SubViewport.new()
	subviewport.disable_3d = true
	subviewport.transparent_bg = true
	subviewport.size = bottom_texture.get_size()
	
	return subviewport

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
	
	if bottom_texture == null:
		## 没有图像，shader资源无法生效
		warnings.append("Without an image, the shader resource will not take effect.")
	
	return warnings
