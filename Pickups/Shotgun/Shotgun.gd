extends Area

export var ammo = 4

func _on_Shotgun_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		if parent.shotgun.available:
			parent.shotgun.ammo += ammo
		else:
			parent.shotgun.available = true
		queue_free()
