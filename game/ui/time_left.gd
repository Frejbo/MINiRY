extends SubViewport
@onready var label = $AspectRatioContainer/Label

func _process(_delta):
	if Globals.current_level == "0": return
	var time_expectations = Globals.level_time_expectations[Globals.current_level]
	var time_taken = get_parent().time_taken
	
	var current_time_goal : float
	
	if time_taken <= time_expectations["3"]:
		current_time_goal = time_expectations["3"]
	elif time_taken <= time_expectations["2"]:
		$AspectRatioContainer/Anka.texture = load("res://ui/InteAnka.png")
		current_time_goal = time_expectations["2"]
	else:
		$AspectRatioContainer/Starlink/Star2.texture = load("res://ui/InteStar.png")
		label.text = "0.00"
		return
	
	
	label.text = str(int(current_time_goal-time_taken))
