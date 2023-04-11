extends Node3D

@export var loadingscreen : Control

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
	loadingscreen.load_game()
	
	# animate main_menu transforming into loadingscreen, along with animationplayer in the loadingscreen scene.
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var time := 1
	tween.set_parallel(true)
	tween.tween_property($CanvasLayer/meny, "modulate:a", 0, time)
	tween.tween_property($CanvasLayer/titel, "modulate:a", 0, time)
	tween.tween_property($CanvasLayer/levels, "modulate:a", 0, time)
	var cam_final_pos = $Camera3D.position - $Camera3D.transform.basis.z / 2
	tween.tween_property($Camera3D, "position", cam_final_pos, time)
	tween.tween_property($Camera3D, "fov", 80, time)
	tween.tween_property($Camera3D.attributes, "exposure_multiplier", .4, time)
	tween.play()
