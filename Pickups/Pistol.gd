extends Area

func _on_Pistol_area_entered(area):
	var parent = area.get_parent()
	if not parent.slot1.available:
		parent.slot1.available = true
		queue_free()
