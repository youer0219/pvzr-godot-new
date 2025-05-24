@tool
extends CharacterBody2D
class_name Bullet

@export var bullet_data:BulletData:set = _set_data

@onready var image: Sprite2D = $Image

var move_strategy_enable:bool = true

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	collision_layer = GlobalSetting.COLLISION_SETTING.bullet
	
	if move_strategy_enable:
		bullet_data.move_strategy.ready(self)

func _set_data(new_data:BulletData):
	bullet_data = new_data
	
	if not is_node_ready():
		await ready
	
	image.texture = bullet_data.bullet_texture
	collision_mask = GlobalSetting.COLLISION_SETTING.world \
	if bullet_data.can_collide_world else GlobalSetting.COLLISION_SETTING.empty

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if move_strategy_enable:
		bullet_data.move_strategy.physics_process(delta,self)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if bullet_data.bounce_times > 0:
			bullet_data.bounce_times -= 1
			move_strategy_enable = false
			velocity = velocity.bounce(collision.get_normal())
		else:
			## TODO:改为由信号驱动死亡并释放粒子
			queue_free()

func get_bullet_name()->String:
	if bullet_data == null:
		push_error("子弹数据类为空却要求获取子弹的名称！")
		return ""
	return bullet_data.bullet_name
