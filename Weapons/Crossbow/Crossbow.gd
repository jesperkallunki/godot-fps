extends Spatial

var projectile = preload("res://Projectiles/Bolt/Bolt.tscn")

export var firing_rate = 1
export var ammo = 100
export var max_ammo = 100

var firing = false
var equipping = false
var unequipping = false

onready var aim_location = $AimLocation
onready var firing_location = $FiringLocation

export var available = false

func _ready():
	aim_location.cast_to = Vector3(0, 0, -999999999)

func _process(_delta):
	aim_location.force_raycast_update()
	firing_location.look_at(aim_location.get_collision_point(), Vector3(0, 1, 0))

func primary_fire():
	if not (firing or equipping or unequipping) and ammo > 0:
		firing_location.add_child(projectile.instance())
		ammo -= 1
		firing = true
		yield(get_tree().create_timer(firing_rate), "timeout")
		firing = false

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
