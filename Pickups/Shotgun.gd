extends Area

func _on_Shotgun_area_entered(area):
	var parent = area.get_parent()
	if not parent.slot2.available:
		parent.slot2.available = true
		queue_free()
