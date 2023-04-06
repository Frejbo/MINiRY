extends HBoxContainer

const available_modes = [ # eftersom de olika modesen är en enum i förljande ordning: windowed, min, max, exc, full. 
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_FULLSCREEN
]

func _ready():
	if not available_modes.has(Settings.screen_mode): return
	$OptionButton.select(available_modes.find(Settings.screen_mode))

var selected
func _on_option_button_item_selected(index):
	selected = available_modes[index]
	if selected != Settings.screen_mode:
		$apply.disabled = false
		$apply.text = "APPLY"

func _on_apply_pressed():
	Settings.screen_mode = selected
	$apply.disabled = true
	$apply.text = "APPLIED"
