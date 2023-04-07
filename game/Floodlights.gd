extends MeshInstance3D

@export var lights : Array[NodePath]

func _ready():
	update_lighting()
	get_node("/root/Settings").connect("changed", update_lighting)

func update_lighting():
	match Settings.lighting_quality:
		Settings.TWO_SCALE.worse:
			print("Applying worse lights")
			for light_path in lights:
				get_node(light_path).hide()
			$DirectionalLight3D.show()
		
		Settings.TWO_SCALE.bad:
			print("Applying bad lights")
			for light_path in lights:
				get_node(light_path).show()
			$DirectionalLight3D.hide()
