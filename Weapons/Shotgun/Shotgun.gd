extends Spatial

export var damage = 8
export var firing_range = 20
export var firing_rate = 1
export var ammo = 100
export var max_ammo = 100
export var pellets = 16
export var spread = 8

var firing = false

onready var aim_location = $AimLocation

export var available = false

func _ready():
	aim_location.cast_to = Vector3(0, 0, -firing_range)

func _process(_delta):
	aim_location.force_raycast_update()
	
	if Input.is_action_pressed("primary_fire") and not firing and ammo > 0:
		for i in pellets:
			aim_location.rotation_degrees = Vector3(rand_range(-spread, spread), rand_range(-spread, spread), 0)
			check_collision()
			aim_location.force_raycast_update()
		ammo -= 1
		firing = true
		yield(get_tree().create_timer(firing_rate), "timeout")
		firing = false

func check_collision():
	if aim_location.is_colliding():
		var target = aim_location.get_collider()
		print(target.name)
