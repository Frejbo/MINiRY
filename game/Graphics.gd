extends Node


enum QUALITY_SCALE {low, medium, high}

var PARTICLE_QUALITY = QUALITY_SCALE.medium


func _notification(what):
	match what:
		NOTIFICATION_EXIT_TREE:
			# save settings
			var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
			file.store_var(PARTICLE_QUALITY)
		NOTIFICATION_ENTER_TREE:
			if not FileAccess.file_exists("user://settings.json"): return # ingen save-fil hittas, ladda ej.
			var file = FileAccess.open("user://settings.json", FileAccess.READ)
			PARTICLE_QUALITY = file.get
