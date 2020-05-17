extends Area

export var health = 50

func _on_MedKit_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player") and parent.health < parent.max_health:
		parent.health = clamp(parent.health + health, 0, parent.max_health)
		queue_free()
