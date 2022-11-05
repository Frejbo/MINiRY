extends RigidBody3D

@export_enum(IronOre, IronIngot) var item_idx

# IronOre
# IronIngot

func _ready(): update_material()

func update_material():
	for node in $AllItems.get_children():
		node.hide()
	$AllItems.get_child(item_idx).show()
