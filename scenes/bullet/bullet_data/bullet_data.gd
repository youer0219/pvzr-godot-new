extends Resource
class_name BulletData

@export var bullet_name:String
@export var bullet_texture:Texture2D

@export var direction:Vector2 = Vector2.RIGHT
@export var move_strategy:BulletMoveStrategy
@export var can_collide_world:bool = true
@export_range(0,10,1.0) var bounce_times:int = 0
@export var bullet_modifiers:Array[BulletModifier]


## TODO:微调bullet的碰撞体
