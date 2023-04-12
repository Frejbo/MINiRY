extends Node3D

func _ready() -> void:
	Settings.changed.connect(update_lights)

func update_lights() -> void:
	for lamp in get_all_lamps(self):
		match Settings.lighting_quality:
			Settings.TWO_SCALE.worse:
				lamp.hide()
			Settings.TWO_SCALE.bad:
				lamp.show()

func get_all_lamps(node, result=[]):
	if node.get_child_count() > 0:
		for child in node.get_children():
			get_all_lamps(child, result)
	else:
		if node is SpotLight3D or node is OmniLight3D:
			result.append(node)
	return result
