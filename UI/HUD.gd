extends MarginContainer

onready var health = $Container/Player/Health/Label
onready var armor = $Container/Player/Armor/Label

onready var ammo = $Container/Weapon/Ammo/Label

func _ready():
	pass

func _process(_delta):
	pass

func update_health(value):
	if value < 0:
		health.text = str(0)
	else:
		health.text = str(value)

func update_armor(value):
	if value < 0:
		armor.text = str(0)
	else:
		armor.text = str(value)

func update_ammo(value):
	if value < 0:
		ammo.text = str(0)
	else:
		ammo.text = str(value)
