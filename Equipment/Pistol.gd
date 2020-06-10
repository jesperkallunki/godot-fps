extends Spatial

export var damage = 40
export var firing_range = 100
export var firing_rate = 0.5
export var ammo = 60
export var max_ammo = 60
export var available = false

var firing = false
var equipping = false
var unequipping = false

onready var aim_location = $AimLocation

func _ready():
	aim_location.cast_to = Vector3(0, 0, -firing_range)

func _process(_delta):
	aim_location.force_raycast_update()

func primary():
	if not (firing or equipping or unequipping) and ammo > 0:
		ammo -= 1
		check_collision()
		firing = true
		yield(get_tree().create_timer(firing_rate), "timeout")
		firing = false

func secondary():
	pass

func check_collision():
	if aim_location.is_colliding():
		var area = aim_location.get_collider()
		if area.is_in_group("Hitbox"):
			var parent = area.get_parent()
			parent.health -= damage

func equip(speed):
	if not (firing or equipping or unequipping):
		equipping = true
		yield(get_tree().create_timer(speed), "timeout")
		visible = true
		set_process(true)
		equipping = false

func unequip(speed):
	if not (firing or equipping or unequipping):
		unequipping = true
		yield(get_tree().create_timer(speed), "timeout")
		visible = false
		set_process(false)
		unequipping = false
