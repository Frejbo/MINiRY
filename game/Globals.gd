extends Node

enum items {IronOre, IronIngot, IronGear, IronRod, CopperOre, CopperIngot, CopperWire, BadAnka, BadAnkaFrame}
const amount_of_total_items = 8
const item_paths = {
	items.IronOre: "res://items/IronOre.gltf",
	items.IronIngot: "res://items/IronIngot.gltf",
	items.IronGear: "res://items/IronGear.gltf",
	items.IronRod: "res://items/IronRod.gltf",
	items.CopperOre: "res://items/CopperOre.gltf",
	items.CopperIngot: "res://items/CopperIngot.gltf",
	items.CopperWire: "res://items/CopperWire.gltf",
	items.BadAnka: "res://items/BadAnka.gltf",
	items.BadAnkaFrame: "res://items/BadAnkaFrame.gltf",
}
const CONVEYOR_SPEED = .3

var current_level : int

var level_completion = { # sparar hur många stjärnor man fått på varje level.
	"1": 0,
	"2": 0,
	"3": 0
}

var level_requirements = {
	"0": [], # level '0' är sandbox.
	"1": [{"type":items.IronRod, "amount":10}, {"type":items.CopperWire, "amount":10}],
	"2": [{"type":items.BadAnka, "amount":1}],
	"3": [{"type":items.IronGear, "amount":20}, {"type":items.CopperWire, "amount":20}]
}
var level_time_expectations = {
	"1": { # level 1
		"2": 130, # sekunder för att klara 2 stjärnor
		"3": 100 # sekunder för att klara 3 stjärnor
	},
	"2": {
		"2": 70,
		"3": 40
	},
	"3": {
		"2": 150,
		"3": 120
	},
}

# spara i filer
func _notification(what):
	# Om spelet stängs av, spara levlarna.
	if what == NOTIFICATION_EXIT_TREE:
		save_game()

func save_game():
	# spara progress på levlarna.
	var file = FileAccess.open("user://MINiRY.save", FileAccess.WRITE)
	file.store_var(level_completion, false)


func _enter_tree():
	# load data
	if not FileAccess.file_exists("user://MINiRY.save"): return # ingen save-fil hittas, ladda ej.
	var file = FileAccess.open("user://MINiRY.save", FileAccess.READ)
	level_completion = file.get_var()



func _physics_process(delta):
	# Flyttar bandens UV textur för att simulera rotation av bandet. Materialet är länkat.
	# rotera bandens UV textur, kan inte vara i conveyor.gd eftersom materialet är globalt och accellererar för varje utplacerat band isf.
	var belt = preload("res://conveyor/conveyorbelt.gltf").instantiate().get_child(0)
	var belt_uv = belt.get_active_material(0).uv1_offset
	belt_uv.y += CONVEYOR_SPEED * delta
	if belt_uv.y >= 1:
		belt_uv.y -= 1
	belt.get_active_material(0).uv1_offset = belt_uv
