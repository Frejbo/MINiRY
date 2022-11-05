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

@onready var hotbar = get_parent().get_parent().get_node("CanvasLayer/CenterContainer/hotbar")
var hotbar_bg = preload("res://hotbar_bg.tres")
var hotbar_bg_focused = preload("res://hotbar_bg_focused.tres")
func focus_hotbar(index : int) -> bool:
	if hotbar.get_child(index).get('theme_override_styles/panel') == hotbar_bg_focused:
		# focus none
		index = -1
	
	for panel in hotbar.get_children():
		panel.set('theme_override_styles/panel', hotbar_bg)
	if index >= 0:
		hotbar.get_child(index).set('theme_override_styles/panel', hotbar_bg_focused)
		return true
	else: return false

func _input(event):
	if event.is_action_pressed("1"):
		if focus_hotbar(0):
			held_item_name = ITEMS["Conveyor"]
		else:
			held_item_name = ITEMS["None"]
	if event.is_action_pressed("2"):
		if focus_hotbar(1):
			held_item_name = ITEMS["Smelter"]
		else:
			held_item_name = ITEMS["None"]
	if event.is_action_pressed("3"):
		if focus_hotbar(2):
			held_item_name = ITEMS["Constructor"]
		else:
			held_item_name = ITEMS["None"]
	
	
	if event.is_action_pressed("select"):
		
		if is_colliding() and get_collider().is_in_group("clickable"):
			if "Arrow" in get_collider().name:
				get_collider().get_parent().get_parent().click_arrow(get_collider())
		else:
			
			if held_item_name == null: return
			var object = load(held_item_name.replace("blueprint_", "")).instantiate()
			object.global_transform = held_item.global_transform
			main.add_child(object)
	
	if event.is_action_pressed("rotate_left"):
		held_item_rotation-=45
	if event.is_action_pressed("rotate_right"):
		held_item_rotation+=45


func _process(_delta):
#	if held_item.get_child(0).name != held_item.name: #and held_item_name != null
		# Byt ut objektet under held_item till held_item_name
	if held_item.get_child_count() > 0:
		if held_item.get_child(0).name == held_item.name: return
	
	if held_item.get_child_count() > 0: held_item.get_child(0).queue_free()
	if held_item_name != null:
		held_item.add_child(load(held_item_name).instantiate())
	
	# process item
	held_item.global_rotation.z = 0
	held_item.global_rotation.x = 0
	held_item.global_rotation.y = deg_to_rad(held_item_rotation)
	held_item.global_position.y = 0
