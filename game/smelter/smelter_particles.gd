extends Node3D


func _ready():
	update_graphics()
	get_node("/root/Settings").connect("changed", update_graphics)

func update_graphics():
	# set all to false before setting one of them to true
	for node in get_children():
		node.emitting = false
		node.hide()
	
	match Settings.particle_quality:
		Settings.THREE_SCALE.low:
			$GpuParticles3d_low.emitting = true
			$GpuParticles3d_low.show()
		Settings.THREE_SCALE.medium:
			$GpuParticles3d_medium.emitting = true
			$GpuParticles3d_medium.show()
		Settings.THREE_SCALE.high:
			$GpuParticles3d_high.emitting = true
			$GpuParticles3d_high.show()
