extends Node3D

#var map = Globals.level_requirements[Globals.current_level]

var start_time : int
func _ready() -> void:
	start_time = Time.get_ticks_msec()

#func _ready():
	# set screen viewports textures, buggat och ger error om gjort via editorn...
#	screen = load("res://levels/level_" + str(Globals.current_level) + ".tscn").instantiate()
#	add_child(screen)
#	$map/Screen/Sprite3D.texture = screen.get_node("level").get_texture()
#	if Globals.current_level != 0: $map/Screen/time_left.texture = $time_left.get_texture()


func level_clear():
	var player = get_node("/root/main/Player")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var success_screen = load("res://ui/success_screen.tscn").instantiate()
	player.get_node("CanvasLayer").add_child(success_screen)
	
	var level_expectations = Globals.level_time_expectations[Globals.current_level]
	var seconds := (Time.get_ticks_msec() - start_time) / 1000.0
	var star : Globals.stars
	if seconds <= level_expectations[Globals.stars.three]:
		# Ge 3 stjärnor
		star = Globals.stars.three
#		Globals.level_completion[Globals.current_level] = Globals.stars.three
	elif seconds <= level_expectations[Globals.stars.two]:
		# 2 stjärnor
		star = Globals.stars.two
#		Globals.level_completion[Globals.current_level] < Globals.stars.two
	elif seconds <= level_expectations[Globals.stars.one]:
		# 1 stjärna
		star = Globals.stars.one
#		Globals.level_completion[Globals.current_level] = Globals.stars.one
	else:
		star = Globals.stars.zero
	
	Globals.level_completion[Globals.current_level] = star
	Globals.save_game()
