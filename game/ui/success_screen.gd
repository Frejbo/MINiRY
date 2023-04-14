extends AspectRatioContainer

@onready var star1 = $VBoxContainer/AspectRatioContainer/Starlink/Star
@onready var star2 = $VBoxContainer/AspectRatioContainer/Starlink/Star2
@onready var anka = $VBoxContainer/AspectRatioContainer/Anka

func _ready():
	match Globals.level_completion[Globals.current_level]:
		Globals.stars.zero:
			star1.texture = load("res://ui/InteStar.png")
			star2.texture = load("res://ui/InteStar.png")
			anka.texture = load("res://ui/InteAnka.png")
		Globals.stars.one:
			star2.texture = load("res://ui/InteStar.png")
			anka.texture = load("res://ui/InteAnka.png")
		Globals.stars.two:
			anka.texture = load("res://ui/InteAnka.png")
		
		# three stars is standard, no need to asign textures for that.


func _on_avsluta_pressed():
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_packed(load("res://main_menu.tscn"))
