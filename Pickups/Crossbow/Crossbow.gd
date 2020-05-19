extends Area

export var ammo_restore = 6

func _on_Crossbow_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		if parent.crossbow.available:
			parent.crossbow.ammo += ammo_restore
		else:
			parent.crossbow.available = true
		queue_free()
