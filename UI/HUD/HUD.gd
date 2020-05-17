extends MarginContainer

onready var health = $Container/Container/Health/Amount
onready var armor = $Container/Container/Armor/Amount

func update_health(value):
	health.text = str(value)

func update_armor(value):
	armor.text = str(value)
