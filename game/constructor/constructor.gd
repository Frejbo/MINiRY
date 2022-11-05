extends Node3D

var anim = $AnimationPlayer
const can_process = [Globals.items.IronIngot]

func _on_process_area_body_entered(body):
	if not body.is_in_group("item"): return # only smelt items... :flushed:
	
	if not body.item in can_process: return
	
	anim.play("ArmatureAction")
	await anim.animation_finished
	
	if body.item == Globals.items.IronIngot:
		body.item = Globals.items.IronGear # IronOre -> IronIngot
	
	
	body.update_material()
	anim.play_backwards("ArmatureAction")
