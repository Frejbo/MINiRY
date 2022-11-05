extends RayCast3D

@onready var main = get_node("/root/main")
@onready var held_item = $held_item
#@onready var gridMap = get_node("/root/main/GridMap")

var held_item_rotation = 0

var ITEMS = {
	"None": null,
	"Conveyor": "res://conveyor/blueprint_conveyorbelt.tscn",
	"Smelter": "res://smelter/blueprint_smelter.tscn",
	"Constructor": "res://constructor/blueprint_constructor.tscn"
}
var held_item_name = ITEMS["None"]

func _input(event):
	if event.is_action_pressed("1"):
		held_item_name = ITEMS["Conveyor"]
	if event.is_action_pressed("2"):
		held_item_name = ITEMS["Smelter"]
	if event.is_action_pressed("3"):
		held_item_name = ITEMS["Constructor"]
	
	
	
	if event.is_action_pressed("select"):
		if held_item_name == null: return
		var object = load(held_item_name.replace("blueprint_", "")).instantiate()
		object.global_transform = held_item.global_transform
		main.add_child(object)
	
	if event.is_action_pressed("rotate_left"):
		held_item_rotation-=30
	if event.is_action_pressed("rotate_right"):
		held_item_rotation+=30


func _process(_delta):
	if held_item.get_child(0).name != held_item.name and held_item_name != null:
		# Byt ut objektet under held_item till held_item_name
		if held_item.get_child_count() > 0: held_item.get_child(0).queue_free()
		held_item.add_child(load(held_item_name).instantiate())
	
	# process item
	held_item.global_rotation.z = 0
	held_item.global_rotation.x = 0
	held_item.global_rotation.y = deg_to_rad(held_item_rotation)
	held_item.global_position.y = 0
