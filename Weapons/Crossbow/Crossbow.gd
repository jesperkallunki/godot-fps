extends Spatial

export (PackedScene) var projectile

export var firing_rate = 1
export var ammo = 100
export var max_ammo = 100

var firing = false

onready var aim_location = $AimLocation

func _ready():
	aim_location.cast_to = Vector3(0, 0, -1)

func _process(_delta):
	aim_location.force_raycast_update()
	
	if Input.is_action_pressed("primary_fire") and not firing and ammo > 0:
		self.add_child(projectile.instance())
		ammo -= 1
		firing = true
		yield(get_tree().create_timer(firing_rate), "timeout")
		firing = false
