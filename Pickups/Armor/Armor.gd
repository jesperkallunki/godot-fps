extends Area

export var armor = 50

func _on_Armor_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player") and parent.armor < parent.max_armor:
		parent.armor = clamp(parent.armor + armor, 0, parent.max_armor)
		queue_free()
