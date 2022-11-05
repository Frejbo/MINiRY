extends StaticBody3D

@onready var area = $Area3D


func _on_smelt_area_body_entered(body):
	if not body.is_in_group("item"): return # only smelt items... :flushed:
	
	if body.item_idx == 0:
		body.item_idx = Globals.items.IronIngot # IronOre -> IronIngot
	
	
	body.update_material()
