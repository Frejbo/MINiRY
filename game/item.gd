extends RigidBody3D

@export var item:Globals.items

# IronOre
# IronIngot

func _ready(): update_material()

func update_material():
	var index = 0
	for node in $AllItems.get_children():
		node.hide()
#		get_child(index).disabled = true
		index += 1
	$AllItems.get_child(item).show()
#	get_child(item).disabled = false


func check_for_removal():
	if global_position.y < -10:
		queue_free()
