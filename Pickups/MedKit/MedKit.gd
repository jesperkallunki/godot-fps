extends Area

export var heal = 50

func _on_MedKit_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().health < area.get_parent().max_health:
		area.get_parent().health = clamp(area.get_parent().health + heal, 0, area.get_parent().max_health)
		queue_free()
