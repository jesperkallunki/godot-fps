extends MarginContainer

onready var health = $Player/Health/Label
onready var armor = $Player/Armor/Label
onready var ammo = $Equipment/Ammo/Label

func _ready():
	pass

func _process(_delta):
	pass

func update_health(value):
	health.text = str(clamp(value, 0, INF))

func update_armor(value):
	armor.text = str(clamp(value, 0, INF))

func update_ammo(value):
	ammo.text = str(clamp(value, 0, INF))
