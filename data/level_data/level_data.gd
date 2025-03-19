class_name LevelData
extends Resource

const SPRITE_CELL_SIZE := Vector2(16,16)
const MAP_SIZE := Vector2(72,24)

enum LEVEL_TIME_TYPE {DAY,NIGHT}
enum LEVEL_TYPE {
	COMMON_LEVEL, ## 一般战斗
	SPECIAL_LEVEL,## 特殊战斗（僵尸最后一波才到来）
	BOSS_LEVEL    ## BOSS战（强制红色/闪电天空，僵尸最后一波到来，出现BOSS）
}

## 时间
@export var level_time_type:LEVEL_TIME_TYPE
## level类型
@export var level_type:LEVEL_TYPE = LEVEL_TYPE.COMMON_LEVEL
## 天气：是否下雨
@export var is_raining:bool = false
