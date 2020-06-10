extends KinematicBody

export var health = 100
export var max_health = 100
export var armor = 0

export var acceleration = 10
export var speed = 10

export var jumping_force = 15

export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3.UP
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4

var direction = Vector3()
var velocity = Vector3()

var jumping = false
var attacking = false
var chasing = false
var searching = false

onready var fov = $FOV
onready var weapon = $FOV/Fireball

enum {
	SLEEP,
	FIGHT,
	SEARCH
}

var state = SLEEP

var target

func _ready():
	var shape = CylinderMesh.new()
	shape.bottom_radius = 0
	shape.top_radius = 50
	shape.height = 70
	
	var collision = CollisionShape.new()
	collision.set_shape(shape.create_convex_shape())
	collision.rotate_object_local(Vector3(-1, 0, 0), float(deg2rad(90)))
	collision.translate_object_local(Vector3(0, 35, 0))
	
	fov.add_child(collision)

func _process(delta):
	
	match state:
		SLEEP:
			sleep()
		FIGHT:
			fight()
		SEARCH:
			search()
	
	if target:
		var space_state = get_world().direct_space_state
		var intersect_ray = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if intersect_ray.collider == target:
			state = FIGHT
	
	direction = direction.normalized()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y > max_gravity:
			velocity.y = max_gravity
	
	if is_on_floor():
		jumping = false
	
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	
	var snap = Vector3.ZERO
	if not jumping:
		snap = Vector3.DOWN
	
	velocity = move_and_slide_with_snap(velocity, snap, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle))
	
	if health <= 0:
		queue_free()

func sleep():
	if health < max_health:
		state = SEARCH

func fight():
	if target:
		var space_state = get_world().direct_space_state
		var intersect_ray = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if intersect_ray.collider == target:
			direction = target.global_transform.origin - global_transform.origin
			look_at(target.global_transform.origin, floor_normal)
			fov.look_at(target.global_transform.origin, floor_normal)
			weapon.primary()
	else:
		state = SEARCH

func search():
	if not searching or is_on_wall():
		var random_direction = Vector3(rand_range(-999, 999), 0, rand_range(-999, 999))
		direction = random_direction - global_transform.origin
		look_at(random_direction, floor_normal)
		searching = true
		var random_timer = rand_range(1, 3)
		yield(get_tree().create_timer(random_timer), "timeout")
		searching = false

func _on_FOV_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		target = parent

func _on_FOV_area_exited(area):
	var parent = area.get_parent()
	if parent == target:
		target = null
