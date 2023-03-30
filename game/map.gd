extends Node3D


# För vardera spak som är på, spawna ett item vid tillhörande input. Called av en timernode.
func _on_item_spawn_timer_timeout():
	if $IronSpak.power_on: spawn_item($"static-conveyor_in-output/iron_conveyor_inputbelt/input0".global_position, Globals.items.IronOre)
	if $CopperSpak.power_on: spawn_item($"static-conveyor_in-output/copper_conveyor_inputbelt/input1".global_position, Globals.items.CopperOre)


# Spawna 'desired_item' vid 'place_position'.
func spawn_item(place_position : Vector3, desired_item : Globals.items):
	var item = preload("res://item.tscn").instantiate()
	item.item = desired_item
	add_child(item)
	item.global_position = place_position


# När ett item hamnar i arean vid outputbältet skickas det till main 'input_material' och raderas det efter en sekund.
func _on_item_output_area_body_entered(body):
	if not body.is_in_group("item"): return
	await get_tree().create_timer(1).timeout
	get_parent().input_material(body.item)
	body.queue_free()
