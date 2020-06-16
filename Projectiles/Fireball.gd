extends RigidBody

export var damage = 20
export var speed = 10

func _ready():
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * speed)

func _on_Impact_area_entered(area):
	if area.is_in_group("Hitbox"):
		var parent = area.get_parent()
		parent.take_damage(damage)
	queue_free()
