extends Area

export var armor_restore = 50

func _on_ArmorLarge_area_entered(area):
	var parent = area.get_parent()
	if parent.armor < parent.max_armor:
		parent.armor = clamp(parent.armor + armor_restore, 0, parent.max_armor)
		queue_free()
