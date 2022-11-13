extends RayCast3D

@onready var main = get_node("/root/world/main")
@onready var held_item = $held_item
#@onready var gridMap = get_node("/root/main/GridMap")

var held_item_rotation = 0
var can_place = false

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
	if Globals.is_multiplayer: if not get_parent().get_parent().synchronizer.is_multiplayer_authority(): return
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
	
	
	if event.is_action_pressed("select"):
		
		# Pilar på constructor:
		if is_colliding() and get_collider().is_in_group("clickable"):
			if "Arrow" in get_collider().name:
				get_collider().get_parent().get_parent().click_arrow(get_collider())
		else:
			if not can_place: return
			if not is_colliding(): return
			if held_item_name == null: return
			var object = load(held_item_name.replace("blueprint_", "")).instantiate()
			object.global_transform = held_item.global_transform
			if held_item_name == ITEMS["Conveyor"]:
				object.intended_rotation_snapping_help = held_item_rotation # hjälper snapping
			main.add_child(object)
		
		
		# Spak
		if is_colliding() and get_collider().is_in_group("clickable"):
			if get_collider().is_in_group("spak"):
				get_collider().click()
	
	
	if event.is_action_pressed("secondary"):
		# tar bort objekt
		if not is_colliding(): return
		if get_collider() == null: return # kan hända ibland med spammklick
		if get_collider().has_meta("object"):
			get_collider().get_node(get_collider().get_meta("object")).queue_free() # tar bort den säkra noden
		elif get_collider().is_in_group("safe_to_remove"):
			get_collider().queue_free()
	
	
	if event.is_action_pressed("rotate_left"):
		held_item_rotation-=45
		if held_item_rotation < -180: held_item_rotation += 360
	if event.is_action_pressed("rotate_right"):
		held_item_rotation+=45
		if held_item_rotation >= 180: held_item_rotation -= 360


func _process(_delta):
	if not is_colliding():
		held_item.hide()
		return
	
	process_held_item_state()
	held_item.global_position.y = 0
	held_item.global_rotation.z = 0
	held_item.global_rotation.x = 0
	held_item.global_rotation.y = deg_to_rad(held_item_rotation)
	held_item.show()
	
	# Byt ut objektet under held_item till held_item_name
	var actual_name = ""
	if held_item_name != null:
		actual_name = held_item_name.replace(":", "").replace(".", "").replace("/", "")
	if held_item.get_child_count() > 0:
		if held_item.get_child(0).name == actual_name: return
	
	if held_item.get_child_count() > 0: held_item.get_child(0).queue_free()
	if held_item_name != null:
		var object = load(held_item_name).instantiate()
		object.name = held_item_name
		held_item.add_child(object)
	

func process_held_item_state():
	# process object
	await get_tree().process_frame
	if get_collider() == null: return
	if get_collider().is_in_group("snapArea") and !Input.is_action_pressed("ctrl"): # hold ctrl to ignore snapping
		
		
		# snapping
#		print((held_item.global_position - get_collider().get_parent().global_position).normalized())
#		while held_item.get_node().
		
		
		
		print(held_item_rotation)
		print(get_collider().get_parent().intended_rotation_snapping_help)
#		print(round(rad_to_deg(get_collider().get_parent().global_rotation.y)))
		var colliding_rot = get_collider().get_parent().intended_rotation_snapping_help
		if (held_item_rotation == colliding_rot) or (held_item_rotation-180 == colliding_rot) or (colliding_rot-180 == held_item_rotation):
			held_item.global_position = get_collider().get_node("place_position_marker_same_rot").global_position
		else:
			held_item.global_position = get_collider().get_node("place_position_marker_diff_rot").global_position
		load("res://blueprint.tres").albedo_color = Color(60.0/255.0, 90.0/255.0, 255.0/255.0, 150.0/255.0) # blue
		can_place = true
	else:
		if held_item.get_child_count() > 0:
			if held_item.get_child(0).has_node("CollideCheck"):
				var collide_check = held_item.get_child(0).get_node("CollideCheck")
				if collide_check.has_overlapping_areas():
					load("res://blueprint.tres").albedo_color = Color(210.0/255.0, 0.0/255.0, 90.0/255.0, 150.0/255.0) # red
					can_place = false
				else:
					load("res://blueprint.tres").albedo_color = Color(60.0/255.0, 90.0/255.0, 255.0/255.0, 150.0/255.0) # blue
					can_place = true
				
		held_item.global_position = get_collision_point()

