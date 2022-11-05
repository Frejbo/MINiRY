extends RigidBody3D

@export var item:Globals.items

# IronOre
# IronIngot

func _ready(): update_material()

func update_material():
	for node in $AllItems.get_children():
		node.hide()
	$AllItems.get_child(item).show()
