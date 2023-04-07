extends StaticBody3D

func _on_process_area_body_entered(body):
	if not body.is_in_group("item"): return # only smelt items... :flushed:
	
	if body.item == Globals.items.IronOre:
		body.item = Globals.items.IronIngot # IronOre -> IronIngot
	if body.item == Globals.items.CopperOre:
		body.item = Globals.items.CopperIngot # CopperOre -> CopperIngot
	
	
	body.update_material()
