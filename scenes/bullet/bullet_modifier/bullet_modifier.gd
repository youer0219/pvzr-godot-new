extends Resource
class_name BulletModifier


func modified_bullet(_bullet:Bullet,_context:Dictionary = {}):
	assert(false,"应当使用子类并实现该方法！")


static func apply_bullet_modifiers(bullet:Bullet,bullet_modifiers:Array[BulletModifier]):
	for bullet_modifier in bullet_modifiers:
		bullet_modifier.modified_bullet(bullet)
