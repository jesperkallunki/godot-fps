extends MarginContainer

onready var health = $Container/Player/Health/Label
onready var armor = $Container/Player/Armor/Label

onready var ammo = $Container/Weapon/Ammo/Label

func update_health(value):
	health.text = str(value)

func update_armor(value):
	armor.text = str(value)

func update_ammo(value):
	ammo.text = str(value)
