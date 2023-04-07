extends HBoxContainer

func _ready():
	$CheckButton.button_pressed = Settings.sdfgi

func _on_check_button_toggled(button_pressed):
	Settings.sdfgi = button_pressed
