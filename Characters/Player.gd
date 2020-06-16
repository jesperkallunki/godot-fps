extends KinematicBody

export var health: int
export var armor: int

export var acceleration: int
export var run_speed: int
export var sprint_speed: int
export var crouch_speed: int
export var jump_force: int

export var gravity = 50
export var max_gravity = 150
export var floor_normal = Vector3.UP
export var floor_max_angle = 47
export var stop_on_slope = true
export var max_slides = 4
export var sensitivity = 0.1
export var equip_speed = 1

var velocity = Vector3()

var jumping = false
var sprinting = false
var crouching = false

onready var camera = $Camera
onready var hud = $Camera/HUD
onready var slot0 = $Camera/Mace
onready var slot1 = $Camera/Pistol
onready var slot2 = $Camera/Shotgun

var equipment

var equipping = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	slot0.available = true
	equip(slot0)

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
	
	var speed = run_speed
	
	sprinting = false
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
		sprinting = true
	
	if is_on_floor():
		jumping = false
		if Input.is_action_pressed("jump"):
			velocity.y = jump_force
			jumping = true
	
	crouching = false
	if Input.is_action_pressed("crouch") and not (sprinting or jumping):
		speed = crouch_speed
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
	
	if Input.is_action_pressed("primary") and not equipping:
		equipment.primary()
	if Input.is_action_pressed("secondary") and not equipping:
		equipment.secondary()
	
	if Input.is_action_pressed("slot0"):
		equip(slot0)
	if Input.is_action_pressed("slot1"):
		equip(slot1)
	if Input.is_action_pressed("slot2"):
		equip(slot2)
	
	if health <= 0:
		die()
	
	hud.update_health(health)
	hud.update_armor(armor)
	if equipment:
		hud.update_ammo(equipment.ammo)

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_position = event.relative
		camera.rotation.x += -deg2rad(mouse_position.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))
		rotation.y += -deg2rad(mouse_position.x * sensitivity)

func equip(slot):
	if not equipping and equipment != slot and slot.available == true:
		if equipment:
			equipment.visible = false
			equipment.set_process(false)
		equipping = true
		yield(get_tree().create_timer(equip_speed), "timeout")
		equipment = slot
		equipment.set_process(true)
		equipment.visible = true
		equipping = false

func take_damage(value):
	if armor > 0:
		var armor_damage = 0.25 * value
		var health_damage = 0.75 * value
		armor -= armor_damage
		health -= health_damage
	else:
		health -= value

func die():
	print("rip")
