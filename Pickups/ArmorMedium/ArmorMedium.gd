extends Area

export var armor_restore = 25

func _on_ArmorMedium_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player") and parent.armor < 100:
		parent.armor = clamp(parent.armor + armor_restore, 0, 100)
		queue_free()
