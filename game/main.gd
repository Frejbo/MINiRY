extends Node3D

var map = Globals.level_requirements[Globals.current_level]
var time_taken : float = 0
var screen

func _process(delta):
	time_taken+=delta

func _ready():
	# set screen viewports textures, buggat och ger error om gjort via editorn...
	screen = load("res://levels/level_" + str(Globals.current_level) + ".tscn").instantiate()
	add_child(screen)
	$map/Screen/Sprite3D.texture = screen.get_node("level").get_texture()
	if Globals.current_level != 0: $map/Screen/time_left.texture = $time_left.get_texture()


func input_material(item : Globals.items):
	if Globals.current_level == 0: return
	for req_item in map:
		if req_item["type"] == item:
			req_item["amount"]-=1
		if req_item["amount"] <= 0:
			map.erase(req_item)
	
	# edit the screen
	var craft_this = screen.get_node("level/AspectRatioContainer/VBoxContainer/craft_this")
	var found : bool = false
	for i in craft_this.get_children():
		if str(item) in i.name:
			found = true
			continue
	if not found: return
	var label = craft_this.get_node(str(item)+"/Label")
	if label.text.to_int() > 0:
		label.text = str(label.text.to_int() - 1)
	
	if map.size() != 0: return
	# complete level
	var level_expectations = Globals.level_time_expectations[Globals.current_level]
	if time_taken <= level_expectations["3"]:
		# Ge 3 stjärnor
		Globals.level_completion[Globals.current_level] = 3
	elif time_taken <= level_expectations["2"]:
		Globals.level_completion[Globals.current_level] = 2
	else:
		Globals.level_completion[Globals.current_level] = 1
	Globals.save_game()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var success_screen = load("res://ui/success_screen.tscn").instantiate()
	$Player/CanvasLayer.add_child(success_screen)
