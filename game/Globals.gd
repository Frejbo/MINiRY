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
	1: 0,
	2: 0,
	3: 0
}
