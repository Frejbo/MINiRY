extends VBoxContainer

func _ready():
	_on_particle_slider_value_changed(Graphics.PARTICLE_QUALITY)


func _on_particle_slider_value_changed(value):
	print(value)
	match int(value):
		0:
			Graphics.PARTICLE_QUALITY = Graphics.QUALITY_SCALE.low
			$value.text = "LOW"
		1:
			Graphics.PARTICLE_QUALITY = Graphics.QUALITY_SCALE.medium
			$value.text = "MEDIUM"
		2:
			Graphics.PARTICLE_QUALITY = Graphics.QUALITY_SCALE.high
			$value.text = "HIGH"
	
	print("Particle Quality set to " + str(Graphics.PARTICLE_QUALITY))
