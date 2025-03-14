extends Node2D
class_name EntityComponentManager



@export var main_body_canvas_group:CanvasGroup


## 传递伤害。根据BUFF决定着色器的状态。
## 链接下层信号。处理实体受伤/死亡/半血等事件。
## 转发下层的leave-out信号，处理组件离开事件。
