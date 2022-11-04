extends Node3D

@onready var area = $Area3d

func _physics_process(delta):
	for hjul in $hjul.get_children():
		hjul.rotate_z(.03)
	
	# process bodies
	for body in area.get_overlapping_bodies():
		if not body is RigidBody3D : continue
		var forward = -get_global_transform().basis.x
		body.global_transform.origin += forward*.01
