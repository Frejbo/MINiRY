extends RigidBody3D

@export var item:Globals.items = Globals.items.BadAnka

# IronOre
# IronIngot

func _ready(): update_material()

func update_material():
	for node in $AllItems.get_children():
		node.hide()
	$AllItems.get_child(item).show()

func check_for_removal():
	if global_position.y < -10:
		queue_free()
