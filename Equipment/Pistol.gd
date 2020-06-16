extends Spatial

export var damage = 40
export var fire_range = 70
export var fire_rate = 0.5
export var ammo = 60
export var max_ammo = 60
export var available = false

var firing = false

onready var aim_location = $AimLocation

func _ready():
	aim_location.cast_to = Vector3(0, 0, -fire_range)
	
	visible = false
	set_process(false)

func _process(_delta):
	aim_location.force_raycast_update()

func primary():
	if not firing and ammo > 0:
		ammo -= 1
		check_collision()
		firing = true
		yield(get_tree().create_timer(fire_rate), "timeout")
		firing = false

func secondary():
	pass

func check_collision():
	if aim_location.is_colliding():
		var area = aim_location.get_collider()
		if area.is_in_group("Hitbox"):
			var parent = area.get_parent()
			parent.take_damage(damage)
