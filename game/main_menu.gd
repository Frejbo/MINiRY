extends Node3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_spawn_items_timer_timeout():
	var item = load("res://item.tscn").instantiate()
	item.item = Globals.items.IronOre
	$machine.add_child(item)
	item.global_position = $machine/spawn_items.global_position


func _on_remove_items_body_entered(body):
	if body.is_in_group("item"):
		body.queue_free()

func _physics_process(_delta):
	var belt_uv = $machine/conveyorbelt/conveyorbelt/belt.get_active_material(2).uv1_offset
	belt_uv.y += 0.0065
	if belt_uv.y >= 1:
		belt_uv.y = 0
	$machine/conveyorbelt/conveyorbelt/belt.get_active_material(2).uv1_offset = belt_uv


func _on_avsluta_pressed():
	get_tree().quit()


func _on_sandbox_pressed():
	Globals.current_level = "0"
	var game = load("res://main.tscn").instantiate()
	get_parent().add_child(game)
	game.create_player()
	queue_free()


func _on_levels_pressed():
	# Ställ in mängd stjärnor
	var vbox = $CanvasLayer/levels/VBoxContainer
	var index = 1
	for hbox in vbox.get_children():
		for node in hbox.get_children():
			if Globals.level_completion[str(index)] == 0:
				node.get_node("Anka").texture = load("res://ui/InteAnka.png")
				for texture in node.get_node("Starlink").get_children():
					texture.texture = load("res://ui/InteStar.png")
			elif Globals.level_completion[str(index)] == 1:
				node.get_node("Anka").texture = load("res://ui/InteAnka.png")
				node.get_node("Starlink/Star2").texture = load("res://ui/InteStar.png")
			elif Globals.level_completion[str(index)] == 2:
				node.get_node("Anka").texture = load("res://ui/InteAnka.png")
			index += 1
	$CanvasLayer/levels.visible = !$CanvasLayer/levels.visible


func _on_level_button_pressed(extra_arg_0 : String):
	Globals.current_level = extra_arg_0
	var game = load("res://main.tscn").instantiate()
	
#	var screen = load("res://levels/level_" + extra_arg_0 + ".tscn").instantiate()
#	game.get_node("map/Screen/Sprite3D").texture = screen.get_node("level").get_texture()
	get_parent().add_child(game)
	game.create_player()
	queue_free()



#var peer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	Globals.current_level = "0"
	var game = preload("res://main.tscn").instantiate()
	get_parent().add_child(game)
	Globals.peer = ENetMultiplayerPeer.new()
	
	Globals.peer.create_server(6969)
	multiplayer.multiplayer_peer = Globals.peer
	Globals.peer.peer_connected.connect(func(id): game.create_player(id))
	Globals.peer.peer_disconnected.connect(func(id): game.destroy_player(id))
	
	Globals.is_multiplayer = true
	game.create_player()
	queue_free()


func _on_connect_pressed():
	Globals.current_level = "0"
	var game = preload("res://main.tscn").instantiate()
	Globals.peer = ENetMultiplayerPeer.new()
	
	Globals.peer.create_client($CanvasLayer/multiplayer_meny/HBoxContainer/VBoxContainer/TextEdit.text, 6969)
	multiplayer.multiplayer_peer = Globals.peer
	print("anslöt")
	
	Globals.is_multiplayer = true
	
	get_parent().add_child(game)
	queue_free()


func _on_multiplayer_pressed():
	$CanvasLayer/multiplayer_meny.visible = !$CanvasLayer/multiplayer_meny.visible
