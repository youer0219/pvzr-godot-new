@tool
extends ShadersSprite2D
class_name EntityComponentImage

const SHAKE_AND_BLINK :StringName = "shake_and_blink"
const ASHES :StringName = "ashes"

## 视觉： -- shader如何混用或统一
## 是否摇晃
## 灰烬 / 冰冻 / 一般 / 魅惑： 脱离时会恢复一般状态或进入灰烬状态。
## ## 灰烬本身还分两种：静止 / 消失+粒子

## 冰冻效果： 6565ff
const FREEZE_COLOR := "6565FF"

@export var is_ash_disapply:bool
@export var blink_color:Color = Color(1,1,1,1)

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return
	
	#test()

func test():
	await get_tree().create_timer(1.0).timeout
	shake()
	ash()

## TODO:冰冻无效！
func freeze():
	modulate = Color(FREEZE_COLOR)

func shake():
	set_shader_param_by_name(SHAKE_AND_BLINK,"hit_effect",0.1)

func ash():
	set_shader_param_by_name(ASHES,"use_replace_color",true)
	set_shader_param_by_name(ASHES,"replace_color",Color.BLACK)
	if is_ash_disapply:
		var tween:Tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_method(_set_ashes_shader_dissolve_amount,0.0,1.0,1)
		## TODO：添加粒子效果

func blink():
	set_shader_param_by_name(SHAKE_AND_BLINK,"blink_color",blink_color)
	var tween:Tween = create_tween()
	tween.tween_method(_set_blink_shader_blink_intensity,0.0,0.55,0.15)
	tween.tween_interval(0.2)
	tween.tween_method(_set_blink_shader_blink_intensity,0.55,0.0,0.15)

func _set_ashes_shader_dissolve_amount(value:float):
	set_shader_param_by_name(ASHES,"dissolve_amount",value)

func _set_blink_shader_blink_intensity(value:float):
	set_shader_param_by_name(SHAKE_AND_BLINK,"blink_intensity",value)

func _notification(what: int) -> void:
	super(what)
