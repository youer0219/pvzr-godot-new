class_name FireTailBulletModifier
extends BulletModifier

const HALF_BULLET_SPRITE_SIZE_X := 12
const FIRE_TAIL = preload("uid://b2cth0oafw4oe")

func modified_bullet(bullet:Bullet,_context:Dictionary = {}):
	## TODO: 这个“has_fire_tail”有什么更好的实现方法吗？
	if bullet.has_fire_tail:
		return
	
	var fire_tail = FIRE_TAIL.instantiate()
	fire_tail.position.x = -1 * HALF_BULLET_SPRITE_SIZE_X \
	if bullet.bullet_data.direction.x > 0 else HALF_BULLET_SPRITE_SIZE_X
	fire_tail.flip_h = bullet.bullet_data.direction.x < 0
	bullet.image.add_child(fire_tail)
	bullet.has_fire_tail = true
