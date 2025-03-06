class_name ShaderSpriteResource
extends Resource
## sprite-shader类
## 提供材质资源
## 是否启动该资源
## 名称 -- 用来寻找

@export var name:StringName
@export var enable:bool:set = _set_enable
@export var shader_mayerial:Material:set = _set_shader_mayerial


func _set_enable(value:bool):
	if enable != value:
		enable = value
		emit_changed()


func _set_shader_mayerial(value:Material):
	if shader_mayerial != value:
		shader_mayerial = value
		emit_changed()
