extends SubViewport

@export var item : Globals.items:
	set(val):
		place_item(val)
	get:
		return item

# Replaces the object shown with the new 'item'.
func place_item(item):
	while $parent.get_child_count() > 0:
		$parent.get_child(0).queue_free()
	
	var object = load(Globals.item_paths[item]).instantiate()
	$parent.add_child(object)
