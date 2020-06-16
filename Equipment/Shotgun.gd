extends Spatial

export var damage = 8
export var fire_range = 20
export var fire_rate = 1
export var ammo = 100
export var max_ammo = 100
export var pellets = 16
export var spread = 8
export var available = false

var firing = false
var equipping = false
var unequipping = false

onready var aim_location = $AimLocation

func _ready():
	aim_location.cast_to = Vector3(0, 0, -fire_range)
	
	visible = false
	set_process(false)

func _process(_delta):
	aim_location.force_raycast_update()

func primary():
	if not firing and ammo > 0:
		for i in pellets:
			aim_location.rotation_degrees = Vector3(rand_range(-spread, spread), rand_range(-spread, spread), 0)
			check_collision()
			aim_location.force_raycast_update()
		ammo -= 1
		firing = true
		yield(get_tree().create_timer(fire_rate), "timeout")
		firing = false

func check_collision():
	if aim_location.is_colliding():
		var area = aim_location.get_collider()
		if area.is_in_group("Hitbox"):
			var parent = area.get_parent()
			parent.take_damage(damage)
