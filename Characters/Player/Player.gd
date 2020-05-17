extends KinematicBody

export var speed_running = 20
export var speed_sprinting = 30
export var speed_crouching = 10
export var jumping_force = 20
export var acceleration = 20
export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3(0, 1, 0)
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4
export var sensitivity = 0.1

export var health = 100
export var max_health = 100
export var armor = 50
export var max_armor = 100

export var speed_weapon_switch = 1

var sprinting = false
var jumping = false
var crouching = false
var falling = false

var velocity = Vector3()

onready var camera = $Head/Camera

var current_weapon

onready var pistol = $Head/Camera/Pistol
onready var shotgun = $Head/Camera/Shotgun
onready var crossbow = $Head/Camera/Crossbow

onready var hud = $Head/Camera/HUD

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	current_weapon = pistol
	shotgun.set_process(false)
	crossbow.set_process(false)

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	var direction = Vector2();
	if Input.is_action_pressed("forward"):
		direction.y += 1
	if Input.is_action_pressed("backward"):
		direction.y -= 1
	if Input.is_action_pressed("left"):
		direction.x += 1
	if Input.is_action_pressed("right"):
		direction.x -= 1
	
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
	
	falling = false
	if velocity.y < 0:
		falling = true
	
	crouching = false
	if Input.is_action_pressed("crouch") and not (sprinting or jumping or falling):
		speed = speed_crouching
		crouching = true
	
	velocity.y -= gravity * delta
	if velocity.y > max_gravity:
		velocity.y = max_gravity
	
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.y * speed, acceleration * delta)
	
	var snap = Vector3()
	if not jumping:
		snap = Vector3(0, -1, 0)
	
	velocity = move_and_slide_with_snap(velocity, snap, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle))
	
	if Input.is_action_pressed("primary_fire"):
		current_weapon.primary_fire()
	
	if Input.is_action_pressed("weapon0") and current_weapon != pistol and pistol.available == true:
		current_weapon.unequip(speed_weapon_switch)
		pistol.equip(speed_weapon_switch)
		current_weapon = pistol
	if Input.is_action_pressed("weapon1") and current_weapon != shotgun and shotgun.available == true:
		current_weapon.unequip(speed_weapon_switch)
		shotgun.equip(speed_weapon_switch)
		current_weapon = shotgun
	if Input.is_action_pressed("weapon2") and current_weapon != crossbow and crossbow.available == true:
		current_weapon.unequip(speed_weapon_switch)
		crossbow.equip(speed_weapon_switch)
		current_weapon = crossbow
	
	update_hud()

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_position = event.relative
		camera.rotation.x += -deg2rad(mouse_position.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))
		rotation.y += -deg2rad(mouse_position.x * sensitivity)

func update_hud():
	hud.update_health(health)
	hud.update_armor(armor)
