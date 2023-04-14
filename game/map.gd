extends Node3D

var screen : SubViewport

# För vardera spak som är på, spawna ett item vid tillhörande input. Called av en timernode.
func _on_item_spawn_timer_timeout():
	if $IronSpak.power_on: spawn_item($"static-conveyor_in-output/iron_conveyor_inputbelt/input0".global_position, Globals.items.IronOre)
	if $CopperSpak.power_on: spawn_item($"static-conveyor_in-output/copper_conveyor_inputbelt/input1".global_position, Globals.items.CopperOre)


func _ready():
	screen = $Screen/level
	$Screen/Sprite3D.texture = screen.get_texture()


# Spawna 'desired_item' vid 'place_position'.
func spawn_item(place_position : Vector3, desired_item : Globals.items):
	var item = preload("res://items/item.tscn").instantiate()
	item.item = desired_item
	add_child(item)
	item.global_position = place_position


# När ett item hamnar i arean vid outputbältet skickas det till main 'input_material' och raderas det efter en sekund.
#func _on_item_output_area_body_entered(body):
#	get_parent().input_material(body.item)
#	body.queue_free()

func _input_material(body):
	if not body.is_in_group("item"): return
	screen.input_material(body.item)
	await get_tree().create_timer(1).timeout
	body.queue_free()
#	for req_item in required_items_left:
#		if req_item["type"] == item:
#			req_item["amount"]-=1
#		if req_item["amount"] <= 0:
#			required_items_left.erase(req_item)
#
#	# edit the screen
#	var craft_this = screen.get_node("level/AspectRatioContainer/VBoxContainer/craft_this")
#	var found : bool = false
#	for i in craft_this.get_children():
#		if str(item) in i.name:
#			found = true
#			continue
#	if not found: return
#	var label = craft_this.get_node(str(item)+"/Label")
#	if label.text.to_int() > 0:
#		label.text = str(label.text.to_int() - 1)
#
#	if required_items_left.size() != 0: return
#	# complete level
#	var level_expectations = Globals.level_time_expectations[Globals.current_level]
#	var seconds := Time.get_ticks_msec() / 1000
#	if seconds <= level_expectations["3"]:
#		# Ge 3 stjärnor
#		Globals.level_completion[Globals.current_level] = 3
#	elif seconds <= level_expectations["2"]:
#		Globals.level_completion[Globals.current_level] = 2
#	else:
#		Globals.level_completion[Globals.current_level] = 1
#	Globals.save_game()
#
#	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	var success_screen = load("res://ui/success_screen.tscn").instantiate()
#	$Player/CanvasLayer.add_child(success_screen)


