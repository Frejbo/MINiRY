extends Node3D

@onready var area = $conveyorbelt/Area3d

func _physics_process(delta):
	for hjul in $conveyorbelt.get_children():
		if not "hjul" in hjul.name: continue
		hjul.rotate_z(.02)
	
	
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("movable"): continue
		if not body is RigidBody3D : continue
		var forward = -get_global_transform().basis.x
		body.global_transform.origin += forward*.01
