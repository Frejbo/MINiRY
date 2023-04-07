extends HBoxContainer

func _ready():
	for item in Settings.TWO_READABLE_SCALE:
		$OptionButton.add_item(item)
	$OptionButton.select(Settings.lighting_quality)

func _on_option_button_item_selected(index):
	Settings.lighting_quality = index
