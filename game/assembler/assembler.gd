extends StaticBody3D

var processing = false

func _physics_process(_delta):
	if processing: return
	
	var required_materials = [Globals.items.BadAnkaFrame, Globals.items.CopperIngot]
	var taken_materials = []
	
	
	for a_object in $processArea_A.get_overlapping_bodies():
		if not a_object.is_in_group("item"): continue
		if a_object.item in required_materials:
			required_materials.erase(a_object.item)
			taken_materials.append(a_object)
	
	for b_object in $processArea_B.get_overlapping_bodies():
		if not b_object.is_in_group("item"): continue
		if b_object.item in required_materials:
			required_materials.erase(b_object.item)
			taken_materials.append(b_object)
	# om required materials är tom, så har kraven för crafting uppnåtts.
	if required_materials.size() != 0: return
	# craft
	processing = true
	$assembler/AnimationPlayer.play("ArmatureAction")
	await get_tree().create_timer(0.834).timeout # 0.834 är halva tiden av animationen
	taken_materials[0].queue_free()
	taken_materials[1].global_rotation = Vector3.UP
	taken_materials[1].global_position = $ProducedSpawnPosition.global_position
	taken_materials[1].item = Globals.items.BadAnka
	taken_materials[1].update_material()
	await get_tree().create_timer(0.834).timeout # 0.834 är halva tiden av animationen
	processing = false
