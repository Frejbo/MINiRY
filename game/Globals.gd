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

var current_level : String

var level_completion = {
	"1": 0,
	"2": 0,
	"3": 0
}

var level_requirements = {
	"0": [],
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
	if what != NOTIFICATION_EXIT_TREE: return
	save_game()

func save_game():
	var leveldata = "user://MINiRY.save"
	var file = FileAccess.open(leveldata, FileAccess.WRITE)
	file.store_var(level_completion, false)


func _ready():
	var leveldata = "user://MINiRY.save"

	# load data
	if not FileAccess.file_exists("user://MINiRY.save"):
		return
	var file = FileAccess.open(leveldata, FileAccess.READ)
	level_completion = file.get_var(false)
