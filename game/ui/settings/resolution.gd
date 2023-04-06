extends HBoxContainer


const available_resolutions := [
	Vector2i(3840, 2160),
	Vector2i(2560, 1440),
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(960, 540)
]


func _ready():
#	var index := 0
	print("hej")
	for res in available_resolutions:
		var label := str(res.x) + "x" + str(res.y)
		$dropdown.add_item(label)
#		index += 1
	
	# select active item in list to current resolution
	var current_idx = available_resolutions.find(Settings.resolution)
	if current_idx != -1:
		print("current res found")
		$dropdown.select(current_idx)

var selected_res
func _on_option_button_item_selected(index):
	selected_res = Vector2i(available_resolutions[index].x, available_resolutions[index].y)
	
	if selected_res != Settings.resolution:
		$apply.disabled = false
		$apply.text = "APPLY"

func _on_apply_pressed():
	$apply.disabled = true
	$apply.text = "APPLIED"
	Settings.resolution = selected_res
