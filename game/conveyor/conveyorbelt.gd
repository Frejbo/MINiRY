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


#var length = 1.01
#const MIDDLE_LENGTH = 0.5

#func _input(event):
#	if not event.is_action_pressed("select"): return
#	length += 1
#	$conveyorbelt_end.position.x -= MIDDLE_LENGTH
#	$conveyorbelt_middle.scale.x = length
#	$conveyorbelt_middle.position.x -= MIDDLE_LENGTH/2
#
