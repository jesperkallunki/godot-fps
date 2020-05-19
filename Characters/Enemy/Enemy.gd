extends KinematicBody

export var health = 1000000
export var armor = 1000000

export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3(0, 1, 0)
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4

var velocity = Vector3()

func _process(delta):
	velocity.y -= gravity * delta
	if velocity.y > max_gravity:
		velocity.y = max_gravity
	
	var snap = Vector3(0, -1, 0)
	
	velocity = move_and_slide_with_snap(velocity, snap, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle))
