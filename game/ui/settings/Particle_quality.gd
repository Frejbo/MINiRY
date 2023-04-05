extends HBoxContainer

func _ready(): update_labels()

func update_labels():
	$quality.text = Settings.READABLE_SCALE[Settings.particle_quality]
	$HSlider.value = Settings.particle_quality

func _on_h_slider_value_changed(value):
	Settings.particle_quality = value
	update_labels()
