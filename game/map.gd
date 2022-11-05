extends Node3D

@onready var area = $belt/Area3D

func _physics_process(_delta):
	for hjul in get_children():
		if not "hjul" in hjul.name: continue
		hjul.rotate_z(.015)
	
	# move conveyor UVs
	var belt_uv = $belt.get_active_material(2).uv1_offset
	belt_uv.y += 0.0065
	if belt_uv.y >= 1:
		belt_uv.y = 0
	$belt.get_active_material(2).uv1_offset = belt_uv
	
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("movable"): continue
		if not body is RigidBody3D : continue
		var forward = -get_global_transform().basis.x
		body.global_transform.origin += forward*.01



func _on_item_spawn_timer_timeout():
	var item = load("res://item.tscn").instantiate()
	item.item = 0
	item.global_position = $belt/input0.global_position
	add_child(item)
