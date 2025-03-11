extends Resource
class_name DamageData


enum DamageType {
	FRONTAL_DAMAGE,       # 正面伤害
	NON_FRONTAL_DAMAGE,   # 非正面伤害
	PENETRATION_DAMAGE,   # 穿透伤害
	EXPLOSIVE_DAMAGE,     # 爆炸伤害
	CRUSHING_DAMAGE,      # 碾压伤害
	BITE_DAMAGE,          # 啃咬伤害
	SPLASH_DAMAGE         # 溅射伤害
}

@export var damage:float = 1.0
@export var damage_type:DamageType = DamageType.FRONTAL_DAMAGE

## TODO: 施加的buff

## 伤害发出者位置
var from_pos:Vector2
## 伤害承受者位置
var target_pos:Vector2


func get_throw_direction()->int:
	if from_pos.x > target_pos.x:
		return Vector2i.LEFT.x
	else:
		return Vector2i.RIGHT.x
