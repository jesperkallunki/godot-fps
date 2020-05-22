extends KinematicBody

export var health = 100
export var armor = 0

export var acceleration = 10
export var speed = 10

export var jumping_force = 15

export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3(0, 1, 0)
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4

var velocity = Vector3()

var jumping = false

onready var fov = $FOV
onready var los = $FOV/LOS

onready var weapon = $FOV/Fireball

var target

func _ready():
	los.cast_to = Vector3(0, 0, -999999999)

func _process(delta):
	var direction = Vector3()
	
	if target:
		los.look_at_from_position(translation, target.translation, floor_normal)
		los.force_raycast_update()
		if los.is_colliding():
			if los.get_collider().get_parent() == target:
				fov.look_at_from_position(translation, target.translation, floor_normal)
				direction = target.translation - translation
				weapon.primary_fire()
	
	direction = direction.normalized()
	
	if is_on_floor():
		jumping = false
	
	velocity.y -= gravity * delta
	if velocity.y > max_gravity:
		velocity.y = max_gravity
	
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	
	var snap = Vector3()
	if not jumping:
		snap = Vector3(0, -1, 0)
	
	velocity = move_and_slide_with_snap(velocity, snap, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle))
	
	if health <= 0:
		queue_free()

func _on_FOV_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		target = parent

func _on_FOV_area_exited(area):
	var parent = area.get_parent()
	if parent == target:
		target = null
