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


func _ready() -> void:
	set_display_item()


func _on_process_area_body_entered(body) -> void:
	if not body.is_in_group("item"): return # only smelt items... :flushed:
	
	if body.item != made_of[producing]: return
	$construct.play()
	anim.play("constructor")
	await get_tree().create_timer(.7).timeout
	
	if Settings.particle_quality != Settings.THREE_SCALE.low: # smoke is not shown on low particles setting
		$smoke1.restart()
		$smoke2.restart()
	
	if !body.is_inside_tree(): return # ifall man tar bort itemet precis innan den processas
	if made_of[producing] == body.item:
		body.item = producing # converting
	
	body.update_material()


func click_arrow(area) -> void:
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

func set_display_item() -> void:
	# update what item that is being viewed on the machine
	var texture : Texture2D = $item_renderer.get_image(producing)
	get_node("Material_z+").texture = texture
	get_node("Material_z-").texture = texture
