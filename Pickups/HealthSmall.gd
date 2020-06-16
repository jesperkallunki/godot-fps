extends Area

export var health_restore = 10

func _on_HealthSmall_area_entered(area):
	var parent = area.get_parent()
	if parent.health < parent.max_health:
		parent.health = clamp(parent.health + health_restore, 0, parent.max_health)
		queue_free()
