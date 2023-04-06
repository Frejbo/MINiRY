extends HBoxContainer


func _ready():
	$SpinBox.value = Settings.max_fps

func _on_spin_box_value_changed(value):
	Settings.max_fps = value
