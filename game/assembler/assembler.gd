extends StaticBody3D

var inputs = [null, null]
# pseudokod för assemblern.
# areas vid inputs skickar en signal till en funktion när något åker in, funktionen kollar om det som åker in är ett item, om det är ett item lägger den itemet i en Array med platserna 0 och 1, 0 = vänster input och 1 = höger input. En till funktion gör det motsatta. Om ett item lämnar någon area så återställs arean till null.
# Funktionen frågar en annan funktion om assemblern har det som krävs för att starta producera, den funktionen (can_produce()) kollar listan med items som ligger i asemblern, kollar om det är en möjlig kombination för att producera ett annat. Om det är det ger den tillbaks truem, annars false.
# Om den gett tillbaks true så fortsätter den tidigare funktionen med att aktivera en annan funktion som påbörjar produktionen:
# Denna funktion tar bort itemens 'item' grupp temporärt, för att inte spelaren ska kunna ta bort något item medan det produceras. Itemens flyttas i scenträdet till en punkt i assemblern, kopierar transformation för att undvika hack. Listan av inputs som assemblern har rensas även.
# Animationen för maskinen startar, samtidigt som funktionen räknar ner till olika tidspunkter där saker ska hända.
# 0,6 sekunder: item A flyttas i scenträdet till klon, kopiera transformation.
# 2,4 (1,8' senare) sekunder: item A tas bort.
# 3,6 (1,2' senare) sekunder: item B flyttas i scenträdet till klon, kopiera transformation.
# 5,5 (1,9' senare) sekunder: item B görs om till det producerade itemet.
# 7,2 (1,7' senare) sekunder: item B flyttas tillbaka i scenträdet till platsen den var på förut, och placeras i gruppen 'item' igen.
# 8,1 (0,9' senare) sekunder: assemblerns animation är återställd och kan producera något nytt.

@onready var klo = $assembler/Armature/Skeleton3D/BoneAttachment3D/picked_item_parent
@onready var anim = $assembler/AnimationPlayer
const recepies := {
	Globals.items.BadAnka : [Globals.items.BadAnkaFrame, Globals.items.CopperIngot]
}
signal ready_to_produce

func _on_input_area_body_entered(body, area : int) -> void: # area A = 0, area B = 1.
	if !body.is_in_group("item"): return # only items
	if !area in [0, 1]:
		push_error("area was falsely binded in assembler. Only '0' or '1' is allowed, 0 for left input and 1 for right input.")
	inputs[area] = [body.item, body]
	
	check_to_produce()

func _on_input_area_body_exit(body, area: int) -> void:
	if !body.is_in_group("item"): return
	if !area in [0, 1]:
		push_error("area was falsely binded in assembler. Only '0' or '1' is allowed, 0 for left input and 1 for right input.")
	inputs[area] = null


func check_to_produce():
	if !can_produce(): return
	if anim.is_playing(): return
	produce(inputs[0][1], inputs[1][1])


var currently_producing = null
func can_produce() -> bool:
	if inputs[0] == null or inputs[1] == null: return false
	
	var index := 0
	for i in recepies:
		if !inputs[0][0] in recepies[i]: continue
		if !inputs[1][0] in recepies[i]: continue
		currently_producing = recepies.keys()[index]
		index += 1
		return true
	return false

func produce(item_A, item_B):
	inputs = [null, null]
	item_A.remove_from_group("item")
	item_B.remove_from_group("item")
	
	anim.play("ArmatureAction002")
	$Screen/AssemblerStatusScreen.started_producing(currently_producing, anim.current_animation_length)
	
	await get_tree().create_timer(.6).timeout
	# flytta item A till klon
	move_node(item_A, klo)
	item_A.freeze = true
	
	await get_tree().create_timer(1.8).timeout
	# ta bort item A
	item_A.queue_free()
	
	await get_tree().create_timer(1.2).timeout
	# flytta item B till klon
	var parent_before = item_B.get_parent()
	move_node(item_B, klo)
	item_B.freeze = true
	
	await get_tree().create_timer(1.9).timeout
	# Gör om item B till det producerade itemet
	item_B.item = currently_producing
	item_B.update_material()
	
	await get_tree().create_timer(1.7).timeout
	# Flytta tillbaks item B och ge tillbaks item taggen
	move_node(item_B, parent_before, true)
	item_B.freeze = false
	item_B.add_to_group("item")
	
	await anim.animation_finished
	emit_signal("ready_to_produce")
	


func move_node(node, new_parent, keep_transform := false) -> void:
	if !node.is_inside_tree(): return # can happen if user deletes it while animation started.
	
	var node_transform = node.global_transform
	
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	
	if keep_transform:
		node.global_transform = node_transform
	else:
		node.position = Vector3.ZERO
		node.rotation = Vector3.ZERO

# debug, place items
#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("left"):
#		var item = load("res://items/item.tscn").instantiate()
#		item.item = Globals.items.IronRod
#		$Node3D/A.add_child(item)
#
#	if event.is_action_pressed("right"):
#		var item = load("res://items/item.tscn").instantiate()
#		item.item = Globals.items.CopperOre
#		$Node3D/B.add_child(item)
