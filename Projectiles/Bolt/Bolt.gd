extends RigidBody

export var damage = 100
export var speed = 10

func _ready():
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * speed)


func _on_Impact_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Target"):
		parent.health -= damage
		queue_free()
