extends Node3D

@onready var belts = [$belt, $belt001]

func _physics_process(_delta):
	for hjul in get_children():
		if not "hjul" in hjul.name: continue
		if "90deg" in hjul.name:
			hjul.rotate_x(.015)
		else:
			hjul.rotate_z(.015)
	
	# move conveyor UVs
	var belt_uv = $belt.get_active_material(2).uv1_offset
	belt_uv.y += 0.0065
	if belt_uv.y >= 1:
		belt_uv.y = 0
	$belt.get_active_material(2).uv1_offset = belt_uv
	
	for belt in belts:
		var area = belt.get_node("Area3D")
		for body in area.get_overlapping_bodies():
			if not body.is_in_group("movable"): continue
			if not body is RigidBody3D : continue
			
			
			var forward = -belt.get_global_transform().basis.x
			body.global_transform.origin += forward.rotated(Vector3.UP, deg_to_rad(belt.get_meta("rotation"))) *.01



func _on_item_spawn_timer_timeout():
	var item = load("res://item.tscn").instantiate()
	item.item = 0
	item.global_position = $belt/input0.global_position
	add_child(item)
