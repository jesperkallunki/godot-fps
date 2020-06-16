extends Area

export var armor_restore: int
export var limit: int

func _on_ArmorLarge_area_entered(area):
	var parent = area.get_parent()
	if parent.armor < limit:
		parent.armor = clamp(parent.armor + armor_restore, 0, limit)
		queue_free()
