extends HBoxContainer

@onready var image_size : Vector2i = custom_minimum_size
@export var item_renderer : SubViewport

func _ready():
	add_item(Globals.items.CopperWire, 5)

func add_item(item : Globals.items, amount):
	var vb = VBoxContainer.new()
	vb.add_theme_constant_override("separation", -50)
	var texture = TextureRect.new()
	texture.texture = item_renderer.get_image(item, image_size)
	var label = Label.new()
	label.text = str(amount)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.theme = load("res://ui/level amount label.tres")
	
	vb.add_child(texture)
	vb.add_child(label)
	add_child(vb)
