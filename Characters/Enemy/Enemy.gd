extends KinematicBody

export var health = 50
export var armor = 0

export var speed = 5
export var acceleration = 5

export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3(0, 1, 0)
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4

var velocity = Vector3()

var falling = false

onready var vision = $Vision

onready var weapon = $Vision/Fireball

var target

func _process(delta):
	var direction = Vector3();
	
	if target:
		direction = target.translation - translation
		vision.look_at(target.translation, floor_normal)
		weapon.primary_fire()
	
	direction = direction.normalized()
	
	falling = false
	if velocity.y < 0:
		falling = true
	
	velocity.y -= gravity * delta
	if velocity.y > max_gravity:
		velocity.y = max_gravity
	
	if not weapon.firing:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	
	var snap = Vector3(0, -1, 0)
	
	velocity = move_and_slide_with_snap(velocity, snap, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle))

func _on_Vision_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		target = parent
		print(target)
