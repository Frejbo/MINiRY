extends HBoxContainer

const image_size := Vector2i(400, 400)
var item_renderer = preload("res://items/item_image_render.tscn")

var displayed_items : Dictionary = {}

func add_item(item:Globals.items, amount:int):
	var vb = VBoxContainer.new()
	vb.add_theme_constant_override("separation", -70)
	var texture = TextureRect.new()
	
	var renderer = item_renderer.instantiate()
	vb.add_child(renderer)
	
	texture.texture = renderer.get_image(item, image_size)
	var label = Label.new()
	label.text = str(amount)
	label.name = "amount"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.theme = load("res://ui/level amount label.tres")
	
	vb.add_child(texture)
	vb.add_child(label)
	add_child(vb)
	
	displayed_items[item] = {"vb":vb, "amount":amount}

func remove_item(item:Globals.items, amount:int = 1):
	if !displayed_items.has(item): return # return if "item" is not displayed
	
	displayed_items[item]["amount"] -= amount
	
	if displayed_items[item]["amount"] <= 0:
		displayed_items[item]["vb"].queue_free()
		displayed_items.erase(item)
		if displayed_items.is_empty(): # All parts were delivered, success
			print("Success!")
			get_node("/root/main").level_clear()
		return
	
	# change screen text
	displayed_items[item]["vb"].get_node("amount").text = str(displayed_items[item]["amount"])
