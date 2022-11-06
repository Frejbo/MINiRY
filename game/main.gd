extends Node3D

var map = Globals.level_requirements[Globals.current_level]
var time_taken : float = 0

func _process(delta):
	time_taken+=delta

func _ready():
	# set screen viewports textures, buggat och ger error om gjort via editorn...
#	$map/Screen/SubViewport/AspectRatioContainer/TextureRect.texture = $Anka.get_texture()
	var screen = load("res://levels/level_" + Globals.current_level + ".tscn").instantiate()
	add_child(screen)
	$map/Screen/Sprite3D.texture = screen.get_node("level").get_texture()

func input_material(item : Globals.items):
	if Globals.current_level == "0": return
	for req_item in map:
		if req_item["type"] == item:
			req_item["amount"]-=1
		if req_item["amount"] <= 0:
			map.erase(req_item)
	
	if map.size() != 0: return
	# complete level
	print("Level completed")
	
	var time = time_taken
	var level_expectations = Globals.level_time_expectations[Globals.current_level]
	if time <= level_expectations["3"]:
		# Ge 3 stjärnor
		Globals.level_completion[Globals.current_level] = 3
	elif time <= level_expectations["2"]:
		Globals.level_completion[Globals.current_level] = 2
	else:
		Globals.level_completion[Globals.current_level] = 1
	
	get_tree().change_scene_to_packed(load("res://main_menu.tscn"))

# [{"type":items.IronRod, "amount":10}, {"type":items.CopperWire, "amount":10}]
