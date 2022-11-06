extends Node3D



func _on_spawn_items_timer_timeout():
	var item = load("res://item.tscn").instantiate()
	item.item = Globals.items.IronOre
	item.global_position = $machine/spawn_items.global_position
	$machine.add_child(item)


func _on_remove_items_body_entered(body):
	if body.is_in_group("item"):
		body.queue_free()

func _physics_process(delta):
	var belt_uv = $machine/conveyorbelt/conveyorbelt/belt.get_active_material(2).uv1_offset
	belt_uv.y += 0.0065
	if belt_uv.y >= 1:
		belt_uv.y = 0
	$machine/conveyorbelt/conveyorbelt/belt.get_active_material(2).uv1_offset = belt_uv


func _on_avsluta_pressed():
	get_tree().quit()


func _on_sandbox_pressed():
	get_tree().change_scene_to_packed(load("res://main.tscn"))


func _on_levels_pressed():
	$CanvasLayer/levels.visible = !$CanvasLayer/levels.visible
