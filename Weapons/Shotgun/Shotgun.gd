extends Spatial

export var damage = 8
export var firing_range = 20
export var firing_rate = 1
export var ammo = 100
export var max_ammo = 100
export var pellets = 16
export var spread = 8

var firing = false
var equipping = false
var unequipping = false

onready var aim_location = $AimLocation

export var available = false

func _ready():
	aim_location.cast_to = Vector3(0, 0, -firing_range)

func _process(_delta):
	aim_location.force_raycast_update()

func primary_fire():
	if not (firing or equipping or unequipping) and ammo > 0:
		print("SUURPUM")
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
		var area = aim_location.get_collider()
		area.get_parent().health -= damage

func equip(speed):
	if not (firing or equipping or unequipping):
		equipping = true
		yield(get_tree().create_timer(speed), "timeout")
		self.set_process(true)
		equipping = false

func unequip(speed):
	if not (firing or equipping or unequipping):
		unequipping = true
		yield(get_tree().create_timer(speed), "timeout")
		self.set_process(false)
		unequipping = false
