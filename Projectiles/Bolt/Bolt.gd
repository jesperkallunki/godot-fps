extends RigidBody

export var damage = 100
export var speed = 10

func _ready():
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * speed)
