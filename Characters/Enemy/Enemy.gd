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
var fighting = false

onready var fov = $FOV
onready var los = $FOV/LOS

onready var weapon = $FOV/Fireball

var target
var target_translation
var last_target_translation
var direction = Vector3()
var searching = false

func _ready():
	los.cast_to = Vector3(0, 0, -999999999)

func _process(delta):
	if target:
		target_translation = target.translation
		los.look_at(target_translation, floor_normal)
		los.force_raycast_update()
		if los.is_colliding():
			if los.get_collider().get_parent() == target:
				fov.look_at(target_translation, floor_normal)
				direction = target_translation - translation
				last_target_translation = target_translation
				fighting = true
				weapon.primary_fire()
			elif last_target_translation != null:
				fov.look_at(last_target_translation, floor_normal)
				direction = last_target_translation - translation
				if translation.distance_to(last_target_translation) < 1:
					last_target_translation = null
			elif not (searching or is_on_wall()) and fighting:
				direction = Vector3(rand_range(-999, 999), 0, rand_range(-999, 999)) - translation
				fov.look_at(direction, floor_normal)
				searching = true
				yield(get_tree().create_timer(int(rand_range(1, 4))), "timeout")
				searching = false
	elif fighting:
		if last_target_translation != null:
			fov.look_at(last_target_translation, floor_normal)
			direction = last_target_translation - translation
			if translation.distance_to(last_target_translation) < 1:
				last_target_translation = null
		elif not searching or is_on_wall():
			direction = Vector3(rand_range(-999, 999), 0, rand_range(-999, 999)) - translation
			fov.look_at(direction, floor_normal)
			searching = true
			yield(get_tree().create_timer(int(rand_range(1, 4))), "timeout")
			searching = false
	
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
