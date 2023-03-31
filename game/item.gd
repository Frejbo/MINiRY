extends RigidBody3D

@export var item:Globals.items

func _ready(): update_material()

func update_material():
	for node in $AllItems.get_children():
		node.hide()
	$AllItems.get_child(item).show()


func check_for_removal():# called from timer-node
	if global_position.y < -10:
		queue_free()
