extends Node3D

@onready var area = $conveyorbelt/Area3d

func _physics_process(delta):
	# flyttar objekt på bandet
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("movable"): continue
		var forward = -get_global_transform().basis.x
		body.global_transform.origin += forward*Globals.CONVEYOR_SPEED*delta*2
	
	# roterar hjulen
	for node in $conveyorbelt/belt.get_children(): # för alla nodes under belt
		if not node is MeshInstance3D: continue # endast hjulen ska rotera
		node.rotate_z(Globals.CONVEYOR_SPEED * delta * 5) # rotera hjulet 'node'.
