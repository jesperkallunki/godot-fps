extends Area

export var health_restore: int
export var limit: int

func _on_HealthMedium_area_entered(area):
	var parent = area.get_parent()
	if parent.health < limit:
		parent.health = clamp(parent.health + health_restore, 0, limit)
		queue_free()
