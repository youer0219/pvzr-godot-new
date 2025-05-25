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
	elif bullet.get_bullet_name() == ICE_PEA_NAME:
		bullet.bullet_data = PEA.duplicate()
