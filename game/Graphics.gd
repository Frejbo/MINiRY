extends Node


enum QUALITY_SCALE {low, medium, high}

var PARTICLE_QUALITY = QUALITY_SCALE.medium


func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		# save settings
		var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
		file.store_var(PARTICLE_QUALITY)
