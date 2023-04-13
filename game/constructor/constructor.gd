extends StaticBody3D

@onready var anim := $constructor/AnimationPlayer
const can_produce := [Globals.items.IronGear, Globals.items.IronRod, Globals.items.CopperWire, Globals.items.BadAnkaFrame]
var producing := Globals.items.IronGear

const made_of := {
	Globals.items.IronGear: Globals.items.IronIngot,
	Globals.items.IronRod: Globals.items.IronIngot,
	Globals.items.CopperWire: Globals.items.CopperIngot,
	Globals.items.BadAnkaFrame: Globals.items.IronIngot
}


func _ready():
	get_node("Material_z+").texture = $Item.get_texture()
	get_node("Material_z-").texture = $Item.get_texture()


func _on_process_area_body_entered(body):
	if not body.is_in_group("item"): return # only smelt items... :flushed:
	
#	if not body.item in can_process: return
	if body.item != made_of[producing]: return
	$AudioStreamPlayer3D.play()
	anim.play("constructor")
	await get_tree().create_timer(.7).timeout
	
	if Settings.particle_quality != Settings.THREE_SCALE.low: # smoke is not shown on low particles setting
		$GPUParticles3D.restart()
		$GPUParticles3D2.restart()
	
	if !body.is_inside_tree(): return # ifall man tar bort itemet precis innan den processas
	if made_of[producing] == body.item:
		body.item = producing # converting
	
	body.update_material()


func click_arrow(area):
	if "Right" in area.name:
		producing += 1
		while not producing in can_produce:
			producing += 1
			if producing > Globals.items.size(): producing = 0 
		$AnimationArrows.play("RightArrows")
	
	if "Left" in area.name:
		producing -= 1
		while not producing in can_produce:
			producing -= 1
			if producing < 0: producing = Globals.items.size()
		$AnimationArrows.play("LeftArrows")
	set_display_item()

func set_display_item():
	# update what item that is being viewed on the machine
	var item_node : Node3D = $Item/item
	item_node.get_child(0).queue_free()
	
	var item = load(Globals.item_paths[producing]).instantiate()
	item_node.add_child(item)
