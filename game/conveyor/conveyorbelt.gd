extends Node3D

@onready var area := $conveyorbelt/Area3d

func _physics_process(delta):
	# Lägger till DETTA bands velocity till objektet på bandet. (Flera band kan påverka ett objekt samtidigt)
	for body in area.get_overlapping_bodies():
		var forward : Vector3 = -get_global_transform().basis.x
		if !body.has_meta("conveyor_move_velocity"): continue
		var arr : Array = body.get_meta("conveyor_move_velocity")
		if arr == null: arr = []
		arr.append(forward)
		body.set_meta("conveyor_move_velocity", arr)
		call_deferred("move_body", body, delta) # Ska ske i slutet av framen, eftersom alla conveyorbelts måste appendat sin forward velocity innan rörelsen kan ske.
	
	
	# roterar hjulen
	for node in $conveyorbelt/belt.get_children(): # för alla nodes under belt
		if not node is MeshInstance3D: continue # endast hjulen ska rotera
		node.rotate_z(Globals.CONVEYOR_SPEED * delta * 5) # rotera hjulet 'node'.

# Flyttar objektet 'body'. Sker i slutet av framen där metadatan innehåller en lista av vectorer för alla band som påverkat objektet.
# Detta gör att objektet inte åker dubbelt så snabbt när det byter mellan de två banden.
func move_body(body, delta : float):
	var vel := Vector3.ZERO
	for vec in body.get_meta("conveyor_move_velocity"):
		vel += vec
	vel = vel.normalized()
	vel = vel.limit_length(Globals.CONVEYOR_SPEED*delta*2)
	body.global_position += vel
	body.set_meta("conveyor_move_velocity", [])
