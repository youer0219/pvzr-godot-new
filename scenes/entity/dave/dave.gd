class_name Dave
extends CharacterBody2D

## TODO: 不知道该如何决定图像和碰撞体的位置。这方面等寻路和放置功能实现时再做考虑。

enum DAVE_SPRITE_TYPE {COMMON,ACE,ZOOM}
@export var dave_sprite_type:DAVE_SPRITE_TYPE:set = _set_dave_sprite_type

@onready var image: Sprite2D = %Image


func _set_dave_sprite_type(value:DAVE_SPRITE_TYPE):
	dave_sprite_type = value
	
	if not is_node_ready():
		await ready
	
	match dave_sprite_type:
		DAVE_SPRITE_TYPE.COMMON:
			image.region_rect = Rect2(74,0,16,32)
		DAVE_SPRITE_TYPE.ACE:
			image.region_rect = Rect2(42,0,16,32)
		DAVE_SPRITE_TYPE.ZOOM:
			image.region_rect = Rect2(10,0,16,32)
