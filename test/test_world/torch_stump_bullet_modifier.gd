class_name TorchStumpBulletModifier
extends BulletModifier

const PEA_NAME := "pea"
const ICE_PEA_NAME := "ice_pea"

const PEA = preload("uid://dynu6bascbsps")
const FIRE_PEA = preload("uid://85xhpdi7i37k")
const FIRE_TAIL = preload("uid://b2cth0oafw4oe")

func modified_bullet(bullet:Bullet,_context:Dictionary = {}):
	if bullet.get_bullet_name() == PEA_NAME:
		bullet.bullet_data = FIRE_PEA.duplicate()
		## TODO:将这件事情转交给bullet-data负责，可能需要新建一个策略，当然，直接实现也行
		var fire_tail = FIRE_TAIL.instantiate()
		fire_tail.position.x = -12 if bullet.bullet_data.direction.x > 0 else 12
		fire_tail.flip_h = bullet.bullet_data.direction.x < 0
		bullet.image.add_child(fire_tail)
	elif bullet.get_bullet_name() == ICE_PEA_NAME:
		bullet.bullet_data = PEA.duplicate()
