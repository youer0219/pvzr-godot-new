extends BulletModifier
class_name IceEffectBulletModifier

const ICE_IMAGE_COLOR := Color("6565ff")

func modified_bullet(bullet:Bullet,_context:Dictionary = {}):
	bullet.image.self_modulate = ICE_IMAGE_COLOR
