extends Node
#A game factory playground, 20x20 meters with walls. Cool dark lightning. Videogame concept art
enum items {IronOre, IronIngot, IronGear, IronRod, CopperOre, CopperIngot, CopperWire, BadAnka, BadAnkaFrame}
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
const CONVEYOR_SPEED = .5

var current_level : int


# Vad som krävs för att klara de olika levlarna.
const level_requirements = { # väljer att används dictionary istället för lista/array här eftersom det inte är viktigt vilken ordning de ligger i, men det är viktigt att rätt level hämtas snarare än att hämta "den på plats 2".
	0: [], # level '0' är sandbox.
	1: [{"type":items.IronRod, "amount":10}, {"type":items.CopperWire, "amount":10}],
	2: [{"type":items.BadAnka, "amount":1}],
	3: [{"type":items.IronGear, "amount":20}, {"type":items.CopperWire, "amount":20}]
}
enum stars {zero, one, two, three}
const level_time_expectations = {
	1: { # level 1
		stars.one: 140, # sekunder för att klara 1 stjärna
		stars.two: 100, # sekunder för att klara 2 stjärnor
		stars.three: 70 # sekunder för att klara 3 stjärnor
	},
	2: { # level 2
		stars.one: 75,
		stars.two: 70,
		stars.three: 40
	},
	3: {
		stars.one: 180,
		stars.two: 150,
		stars.three: 120
	},
}
var level_completion = { # sparar hur många stjärnor man fått på varje level.
	1: stars.zero,
	2: stars.zero,
	3: stars.zero
}


func save_game():
	# spara progress på levlarna
	var file = FileAccess.open("user://MINiRY.save", FileAccess.WRITE)
	file.store_var(level_completion)


func _enter_tree():
	# ladda progress på levlarna
	if not FileAccess.file_exists("user://MINiRY.save"): return # ingen save-fil hittas, ladda ej.
	var file = FileAccess.open("user://MINiRY.save", FileAccess.READ)
	level_completion = file.get_var()



func _physics_process(delta):
	# Flyttar bandens UV textur för att simulera rotation av bandet. Materialet är länkat.
	# rotera bandens UV textur, kan inte vara i conveyor.gd eftersom materialet är globalt och accellererar för varje utplacerat band isf.
	var belt = preload("res://conveyor/conveyorbelt.gltf").instantiate().get_child(0)
	var belt_uv = belt.get_active_material(0).uv1_offset
	belt_uv.y -= CONVEYOR_SPEED * delta
	if belt_uv.y <= 0:
		belt_uv.y += 1
	belt.get_active_material(0).uv1_offset = belt_uv
