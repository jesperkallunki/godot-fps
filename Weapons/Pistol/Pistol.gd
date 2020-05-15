extends Spatial

export var damage = 40
export var firing_range = 100
export var firing_rate = 0.5
export var ammo = 100
export var max_ammo = 100

var firing = false

onready var aim_location = $AimLocation

func _ready():
	aim_location.cast_to = Vector3(0, 0, -firing_range)

func _process(_delta):
	aim_location.force_raycast_update()
	
	if Input.is_action_pressed("primary_fire") and not firing and ammo > 0:
		ammo -= 1
		check_collision()
		firing = true
		yield(get_tree().create_timer(firing_rate), "timeout")
		firing = false

func check_collision():
	if aim_location.is_colliding():
		var area = aim_location.get_collider()
		area.get_parent().health -= damage
		print(area.get_parent().health)
