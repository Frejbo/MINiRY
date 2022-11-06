extends Node

enum items {IronOre, IronIngot, IronGear, IronRod, CopperOre, CopperIngot, CopperWire, BadAnka}
const amount_of_total_items = 7
const item_paths = {
	items.IronOre: "res://items/IronOre.gltf",
	items.IronIngot: "res://items/IronIngot.gltf",
	items.IronGear: "res://items/IronGear.gltf",
	items.IronRod: "res://items/IronRod.gltf",
	items.CopperOre: "res://items/CopperOre.gltf",
	items.CopperIngot: "res://items/CopperIngot.gltf",
	items.CopperWire: "res://items/CopperWire.gltf",
	items.BadAnka: "res://items/BadAnka.gltf"
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
	"3": [{"type":items.BadAnka, "amount":1}]
}
var level_time_expectations = {
	"1": { # level 1
		"2": 120, # sekunder för att klara 2 stjärnor
		"3": 90 # sekunder för att klara 3 stjärnor
	},
	"2": {
		"2": 45,
		"3": 30
	},
	"3": {
		"2": 45,
		"3": 30
	},
}
