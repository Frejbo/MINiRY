extends RayCast3D

@onready var main = get_node("/root/main")
#@onready var gridMap = get_node("/root/main/GridMap")

var held_item_rotation = 0
const RED_BLUEPRINT_TINT = Color(210.0/255.0, 0.0/255.0, 90.0/255.0, 150.0/255.0)
const BLUE_BLUEPRINT_TINT = Color(60.0/255.0, 90.0/255.0, 255.0/255.0, 150.0/255.0)


var ITEMS = {
	"None": null,
	"Conveyor": "res://conveyor/blueprint_conveyorbelt.tscn",
	"Smelter": "res://smelter/blueprint_smelter.tscn",
	"Constructor": "res://constructor/blueprint_constructor.tscn",
	"Assembler": "res://assembler/blueprint_assembler.tscn"
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
	if event.is_action_pressed("4"):
		if focus_hotbar(3):
			held_item_name = ITEMS["Assembler"]
		else:
			held_item_name = ITEMS["None"]
	
	
	if event.is_action_pressed("primary"):
		
		# Knappar
		if is_colliding() and get_collider().is_in_group("clickable"):
			# Pilar på constructor:
			if "Arrow" in get_collider().name:
				get_collider().get_parent().get_parent().click_arrow(get_collider())
		
		if is_colliding() and can_place():
			# place objects
			var object = load(held_item_name.replace("blueprint_", "")).instantiate()
			object.global_transform = $held_item_parent.global_transform
			object.add_to_group("safe_to_remove")
			main.get_node("buildings").add_child(object)
			object.global_transform = modify_place_position(object)
		
		
		# Spak
		if is_colliding() and get_collider().is_in_group("clickable"):
			if get_collider().is_in_group("spak"):
				get_collider().click()
	
	
	if event.is_action_pressed("secondary"):
		# tar bort objekt
		var body = get_collider()
		if not is_colliding() or body == null: return # kan hända att is_colliding() == true trots att det inte finns någon collider, främst med spammklick.
		if body.has_meta("object"): # ett conveyorbelt i en constructor har metadatan 'object' som pekar på constructorn.
			body = body.get_node(body.get_meta("object")) # refererar om 'body' till det objektet metadatan pekar på
		if body.is_in_group("safe_to_remove"):
			body.queue_free()
	
	
	if event.is_action_pressed("rotate_left"):
		held_item_rotation-=90
		if held_item_rotation < -180: held_item_rotation += 360
	if event.is_action_pressed("rotate_right"):
		held_item_rotation+=90
		if held_item_rotation >= 180: held_item_rotation -= 360

func can_place() -> bool:
	return ($held_item_parent.get_child_count() > 0 and load("res://blueprint.tres").albedo_color == BLUE_BLUEPRINT_TINT)

func _physics_process(_delta):
	if not is_colliding():
		$held_item_parent.hide()
		return
	
	process_held_item_state()
	$held_item_parent.show()
	
	# Byt ut objektet under held_item till held_item_name
	var actual_name = ""
	if held_item_name != null:
		actual_name = held_item_name.replace(":", "").replace(".", "").replace("/", "")
	if $held_item_parent.get_child_count() > 0:
		if $held_item_parent.get_child(0).name == actual_name: return
	
	if $held_item_parent.get_child_count() > 0: $held_item_parent.get_child(0).queue_free()
	if held_item_name != null:
		var object = load(held_item_name).instantiate()
		object.name = held_item_name
		$held_item_parent.add_child(object)
	

func process_held_item_state():
	# process object
	await get_tree().process_frame
	if get_collider() == null: return

	$held_item_parent.global_position = get_collision_point()
	
	if $held_item_parent.get_child_count() > 0:
		if $held_item_parent.get_child(0).has_node("CollideCheck"):
			var collide_check = $held_item_parent.get_child(0).get_node("CollideCheck")
			if collide_check.has_overlapping_areas():
				load("res://blueprint.tres").albedo_color = RED_BLUEPRINT_TINT
			else:
				load("res://blueprint.tres").albedo_color = BLUE_BLUEPRINT_TINT
		
		$held_item_parent.global_transform = modify_place_position($held_item_parent)
		$held_item_parent.global_rotation.y = deg_to_rad(held_item_rotation)


# sätter vissa values till statiska, dessa ska inte kunna ändras.
func modify_place_position(object):
	object.global_position.y = 0
	object.global_position = object.global_position.snapped(Vector3(2, 0, 2))
	object.global_rotation.z = 0
	object.global_rotation.x = 0
	return object.global_transform
