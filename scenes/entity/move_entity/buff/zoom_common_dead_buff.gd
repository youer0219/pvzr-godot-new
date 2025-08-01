extends GD_Buff
class_name ZoomCommonDeadBuff

## 移除组件由管理者自动负责
## 受到伤害死亡时触发倒地，朝伤害反方向倒地(第一次)
## 倒地后受到伤害时，弹跳(第N次) —— 速度方向向上并偏向受击方向另一边
## TODO:未来添加力度系统，不同力度结果不同
## 添加时链接组件的死亡信号

const IS_FIRST_ACTIVE := "is_first_active"

func _on_buff_start(container: GD_BuffContainer, runtime_buff: GD_RuntimeBuff) -> void:
	var zoom := container.get_parent() as Zoom
	runtime_buff.blackboard[IS_FIRST_ACTIVE] = false
	zoom.entity_dead.connect(_on_common_dead.bind(zoom,runtime_buff),ConnectFlags.CONNECT_ONE_SHOT)

func _on_common_dead(damage_data:DamageData,zoom:Zoom,runtime_buff:GD_RuntimeBuff):
	runtime_buff.blackboard[IS_FIRST_ACTIVE] = true
	if runtime_buff.blackboard[IS_FIRST_ACTIVE]:
		zoom.entity_chart.send_event("lay")
		zoom.entity_chart.send_event("dead")
		zoom.collision_shape_2d.position.y -= 8
		zoom.dead_timer.start(3.5) ## 记得在第一次触发时启动计时器
	var direction := damage_data.get_throw_direction()
	var velocity := Vector2(20,-20)
	zoom.last_frame_init_velocity_add += velocity * Vector2(direction,1)
