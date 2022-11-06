extends AspectRatioContainer

func _ready():
	if Globals.level_completion[Globals.current_level] == 0:
		$VBoxContainer/AspectRatioContainer/Anka.texture = load("res://ui/InteAnka.png")
		for texture in $VBoxContainer/AspectRatioContainer/Starlink.get_children():
			texture.texture = load("res://ui/InteStar.png")
	elif Globals.level_completion[Globals.current_level] == 1:
		$VBoxContainer/AspectRatioContainer/Anka.texture = load("res://ui/InteAnka.png")
		$VBoxContainer/AspectRatioContainer/Starlink/Star2.texture = load("res://ui/InteStar.png")
	elif Globals.level_completion[Globals.current_level] == 2:
		$VBoxContainer/AspectRatioContainer/Anka.texture = load("res://ui/InteAnka.png")

func _on_avsluta_pressed():
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_packed(load("res://main_menu.tscn"))
