extends KinematicBody

export var health = 100
export var max_health = 100
export var armor = 0
export var max_armor = 100

export var acceleration = 10
export var speed_running = 10
export var speed_sprinting = 15
export var speed_crouching = 5
export var jumping_force = 15

export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3.UP
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4
export var sensitivity = 0.1

export var speed_weapon_switch = 1

var velocity = Vector3()

var jumping = false
var sprinting = false
var crouching = false

onready var camera = $Camera

var equipment
var slot0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	var direction = Vector2()
	if Input.is_action_pressed("forward"):
		direction.y -= 1
	if Input.is_action_pressed("backward"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	direction = direction.normalized().rotated(-rotation.y)
	
	var speed = speed_running
	
	sprinting = false
	if Input.is_action_pressed("sprint"):
		speed = speed_sprinting
		sprinting = true
	
	if is_on_floor():
		jumping = false
		if Input.is_action_pressed("jump"):
			velocity.y = jumping_force
			jumping = true
	
	crouching = false
	if Input.is_action_pressed("crouch") and not (sprinting or jumping):
		speed = speed_crouching
		crouching = true
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y > max_gravity:
			velocity.y = max_gravity
	
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.y * speed, acceleration * delta)
	
	var snap = Vector3.ZERO
	if not jumping:
		snap = Vector3.DOWN
	
	velocity = move_and_slide_with_snap(velocity, snap, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle))
	
	if equipment:
		if Input.is_action_pressed("primary"):
			equipment.primary()
		if Input.is_action_pressed("secondary"):
			equipment.secondary()
	
	if Input.is_action_pressed("slot0") and equipment != slot0 and slot0.available == true:
		equipment.unequip(speed_weapon_switch)
		slot0.equip(speed_weapon_switch)
		equipment = slot0

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_position = event.relative
		camera.rotation.x += -deg2rad(mouse_position.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))
		rotation.y += -deg2rad(mouse_position.x * sensitivity)
