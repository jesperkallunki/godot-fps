extends Area

export var health_restore = 25

func _on_HealthMedium_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player") and parent.health < 100:
		parent.health = clamp(parent.health + health_restore, 0, 100)
		queue_free()
