extends Node3D

var anim = $AnimationPlayer
var can_produce = [Globals.items.IronGear, Globals.items.IronRod, Globals.items.CopperWire]
var producing = Globals.items.IronGear

var made_of = {
	Globals.items.IronGear: Globals.items.IronIngot,
	Globals.items.IronRod: Globals.items.IronIngot,
	Globals.items.CopperWire: Globals.items.CopperIngot
}

func _on_process_area_body_entered(body):
	if not body.is_in_group("item"): return # only smelt items... :flushed:
	
#	if not body.item in can_process: return
	if body.item != made_of[producing]: return
	
	anim.play("ArmatureAction")
	await anim.animation_finished
	
	if made_of[producing] == body.item:
		body.item = producing # converting
#	if body.item == Globals.items.IronIngot: # måste känna av
	
	
	body.update_material()
	anim.play_backwards("ArmatureAction")


var currently_producing : int = 0
func _process(_delta):
	var item_node = $Item/item
	if currently_producing == producing: return
	# change item
	item_node.get_child(0).queue_free()
	
	var item = load(Globals.item_paths[producing]).instantiate()
	item_node.add_child(item)
	print(producing)
	currently_producing = producing

func click_arrow(area):
	if "Right" in area.name:
		producing += 1
		while not producing in can_produce:
			producing += 1
			if producing > Globals.amount_of_total_items: producing = 0 
		$AnimationArrows.play("RightArrows")
	
	if "Left" in area.name:
		producing -= 1
		while not producing in can_produce:
			producing -= 1
			if producing < 0: producing = Globals.amount_of_total_items
		$AnimationArrows.play("LeftArrows")
