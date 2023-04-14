extends SubViewport

@export var item_manager : HBoxContainer
@onready var to_be_produced = Globals.level_requirements[Globals.current_level]

func _ready() -> void:
	if to_be_produced.size() == 0:
		# Sandbox
		$screen.hide()
		$sandbox.show()
		return
	# level is active
	$screen.show()
	$sandbox.hide()
	
	$screen/VBoxContainer/level_number.text = "LEVEL " + str(Globals.current_level)
	for item in to_be_produced:
		item_manager.add_item(item["type"], item["amount"])
		await get_tree().create_timer(.1).timeout


func input_material(item : Globals.items, amount := 1): # I don't think the amount here will ever be used, but why not pass it along
	if Globals.current_level == 0: return # return if sandbox
	item_manager.remove_item(item, amount)
#	for req_item in to_be_produced:
#		if req_item["type"] == item:
#			req_item["amount"]-=1
#		if req_item["amount"] <= 0:
#			to_be_produced.erase(req_item)


#func _on_level_clear() -> void:
#	var player = get_node("/root/main/Player")
#	print(player)
#	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	var success_screen = load("res://ui/success_screen.tscn").instantiate()
#	player.get_node("CanvasLayer").add_child(success_screen)
