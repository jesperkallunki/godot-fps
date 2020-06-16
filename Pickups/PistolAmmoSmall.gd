extends Area

export var ammo_restore = 12

func _on_PistolAmmoSmall_area_entered(area):
	var parent = area.get_parent()
	if parent.slot1.ammo < parent.slot1.max_ammo:
		parent.slot1.ammo = clamp(parent.slot1.ammo + ammo_restore, 0, parent.slot1.max_ammo)
		queue_free()
