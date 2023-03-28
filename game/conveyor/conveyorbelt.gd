extends Node3D

@onready var area = $conveyorbelt/Area3d

var intended_rotation_snapping_help : int

func _physics_process(_delta):
	for hjul in $conveyorbelt.get_children():
		if not "hjul" in hjul.name: continue
		hjul.rotate_z(.02)
	
	
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("movable"): continue
		var forward = -get_global_transform().basis.x
		body.global_transform.origin += forward*.01
	
	# rotera bandets UV textur
	var belt_uv = $conveyorbelt/belt.get_active_material(0).uv1_offset
	belt_uv.y += 0.0008
	if belt_uv.y >= 1:
		belt_uv.y -= 1
	$conveyorbelt/belt.get_active_material(0).uv1_offset = belt_uv
