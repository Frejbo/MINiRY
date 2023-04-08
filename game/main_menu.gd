extends Node3D

func _ready():
	# Sätter musen till synlig (mest för när man kört spelet och går tillbaks till menyn)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_spawn_items_timer_timeout():
	# varje gång timer-noden börjar om spawnar den ett item i menyn.
	var item = load("res://items/item.tscn").instantiate()
	item.item = Globals.items.IronOre
	$machine.add_child(item)
	item.global_position = $machine/spawn_items.global_position


func _on_remove_items_body_entered(body):
	# När ett item kommer in i en area3D utanför skärmen så tas dem bort.
	if body.is_in_group("item"):
		body.queue_free()

func _on_avsluta_pressed():
	get_tree().quit()


func _on_levels_pressed():
	# Ställ in mängd stjärnor
	var vbox : VBoxContainer = $CanvasLayer/levels/VBoxContainer
	var index : int = 1
	for hbox in vbox.get_children():
		for node in hbox.get_children():
			match Globals.level_completion[str(index)]:
				0:
					node.get_node("Anka").texture = load("res://ui/InteAnka.png")
					for texture in node.get_node("Starlink").get_children():
						texture.texture = load("res://ui/InteStar.png")
				1:
					node.get_node("Anka").texture = load("res://ui/InteAnka.png")
					node.get_node("Starlink/Star2").texture = load("res://ui/InteStar.png")
				2:
					node.get_node("Anka").texture = load("res://ui/InteAnka.png")
			index += 1
	$CanvasLayer/levels.visible = !$CanvasLayer/levels.visible


func _start_level(level : int):
	Globals.current_level = level
	get_tree().change_scene_to_packed(load("res://main.tscn"))
#	var screen = load("res://levels/level_" + extra_arg_0 + ".tscn").instantiate()
#	game.get_node("map/Screen/Sprite3D").texture = screen.get_node("level").get_texture()
