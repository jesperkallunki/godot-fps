extends Area

export var armor = 50

func _on_Armor_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().armor < area.get_parent().max_armor:
		area.get_parent().armor = clamp(area.get_parent().armor + armor, 0, area.get_parent().max_armor)
		queue_free()
