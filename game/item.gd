extends RigidBody3D

@export var item_idx:Globals.items

# IronOre
# IronIngot

func _ready(): update_material()

func update_material():
	for node in $AllItems.get_children():
		node.hide()
	$AllItems.get_child(item_idx).show()
