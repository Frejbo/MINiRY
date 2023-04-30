extends AspectRatioContainer

var time_expectations : Dictionary
const DISABLED_COLOR = Color(.1, .1, .1)
var time := 0.0

func _ready() -> void:
	if Globals.current_level == 0:
		set_process(false) # No need to update this every frame if playing sandbox
	else:
		time_expectations = Globals.level_time_expectations[Globals.current_level]

func _process(delta):
	time += delta
	
	var current_time_goal : float
	
	if time < time_expectations[Globals.stars.three]: # 2 stjärnor
		current_time_goal = time_expectations[Globals.stars.three]
	
	elif time < time_expectations[Globals.stars.two]: # 1 stjärna
		current_time_goal = time_expectations[Globals.stars.two]
		$Anka.modulate = DISABLED_COLOR
	
	elif time < time_expectations[Globals.stars.one]: # 0 stjärnor
		$Starlink/Star2.modulate = DISABLED_COLOR
		current_time_goal = time_expectations[Globals.stars.one]
	
	else:
		$Starlink/Star.modulate = DISABLED_COLOR
		$Label.text = ""
		return
	
	$Label.text = str(snapped(current_time_goal-time, 0.1))

