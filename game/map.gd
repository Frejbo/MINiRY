extends Node3D

@onready var belts = [$belt, $belt001, $belt002]

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
	if $IronSpak.power_on: spawn_item($belt/input0.global_position, Globals.items.IronOre)
	if $CopperSpak.power_on: spawn_item($belt002/input1.global_position, Globals.items.CopperOre)
	
#	print(get_parent().get_node("buildings").get_child_count())

func spawn_item(place_position : Vector3, desired_item : Globals.items):
	var item = preload("res://item.tscn").instantiate()
	item.item = desired_item
	get_parent().get_node("items").add_child(item, true)
	item.global_position = place_position


func _on_item_output_area_body_entered(body):
	if not body.is_in_group("item"): return
	$Lucka/AnimationPlayer.play("Lucka")
	await get_tree().create_timer(1).timeout
	get_parent().input_material(body.item)
	body.queue_free()
