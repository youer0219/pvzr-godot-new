class_name EntityComponent
extends RigidBody2D

## 禁用时：
## 不受力
## 移动/受击时有一些额外的动作，暂时不知道怎么实现。可能使用动画，所以可能需要设置freeze_mode属性。

## 启动后：
## 与世界层碰撞
## 取消各种其他着色器影响。根据伤害类型决定是否灰烬形态。
## 抛出后有一点弹性。梯子等碰撞体很小，且位于顶部。所以可以达到图像没入地面但仍然弹跳的效果
## 入水后有阻尼效果

signal throw_out(entity_component:EntityComponent)

@onready var entity_collision_shape: CollisionShape2D = $EntityCollisionShape

@export var phy_enable:bool = false:set = _set_phy_enable


func _ready() -> void:
	throw_out.connect(
		func(entity_component:EntityComponent):
			print(entity_component.name + " 发出throw_out信号，交给父节点处理")
	)
	
	await get_tree().create_timer(1.0).timeout
	throw(Vector2i.LEFT.x)


func _set_phy_enable(value:bool):
	phy_enable = value
	
	if not is_node_ready():
		await ready
	
	## 抛出时启动物理。启动后，实体组件将与world碰撞。不启动时，实体应该静止并不碰撞。
	freeze = not phy_enable
	entity_collision_shape.set_deferred("disabled", not phy_enable)


func throw(direction:int):
	throw_out.emit(self)
	phy_enable = true
	
	var tween:Tween = create_tween()
	apply_impulse(Vector2(direction * 80 , -400))
	tween.tween_interval(3.0)
	tween.tween_callback(self.queue_free)
