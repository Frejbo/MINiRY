extends SubViewport

# Replaces the object shown with the new 'item'.
func get_image(item:Globals.items, img_size:Vector2i = size) -> Texture2D:
	
	while $parent.get_child_count() > 0:
		$parent.get_child(0).free()
	
	var object = load(Globals.item_paths[item]).instantiate()
	$parent.add_child(object)
	size = img_size
	
	render_target_update_mode = SubViewport.UPDATE_ONCE # update the viewport
	return get_texture()

