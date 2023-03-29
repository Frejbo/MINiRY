extends Node3D

@onready var area = $conveyorbelt/Area3d

var intended_rotation_snapping_help : int

func _physics_process(delta):
	for hjul in $conveyorbelt.get_children():
		if not "hjul" in hjul.name: continue
		hjul.rotate_z(.02)
	
	# flyttar objekt på bandet
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("movable"): continue
		var forward = -get_global_transform().basis.x
		body.global_transform.origin += forward*.01
	
	# roterar hjulen
	for node in $conveyorbelt/belt.get_children(): # för alla nodes under belt
		if not node is MeshInstance3D: continue # endast hjulen ska rotera
		node.rotate_z(Globals.CONVEYOR_SPEED * delta * 5) # rotera hjulet 'node'.
