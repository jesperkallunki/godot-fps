extends RigidBody

export var damage = 100
export var speed = 100

func _ready():
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * speed)

func _on_Impact_area_entered(area):
	if area.is_in_group("Hitbox"):
		var parent = area.get_parent()
		parent.health -= damage
	queue_free()
