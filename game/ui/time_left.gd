extends AspectRatioContainer

@onready var start_time : int = Time.get_ticks_msec()
var time_expectations : Dictionary
func _ready() -> void:
	if Globals.current_level == 0:
		set_process(false) # No need to update this every frame if playing sandbox
	else:
		time_expectations = Globals.level_time_expectations[Globals.current_level]

const DISABLED_COLOR = Color(.1, .1, .1)

func _process(_delta):
	var time_taken := (Time.get_ticks_msec() - start_time) / 1000.0
	
	var current_time_goal : float
	
	if time_taken < time_expectations[Globals.stars.three]: # 2 stjärnor
		current_time_goal = time_expectations[Globals.stars.three]
	
	elif time_taken < time_expectations[Globals.stars.two]: # 1 stjärna
		current_time_goal = time_expectations[Globals.stars.two]
		$Anka.modulate = DISABLED_COLOR
	
	elif time_taken < time_expectations[Globals.stars.one]: # 0 stjärnor
		$Starlink/Star2.modulate = DISABLED_COLOR
		current_time_goal = time_expectations[Globals.stars.one]
	
	else:
		$Starlink/Star.modulate = DISABLED_COLOR
		$Label.text = ""
		return
	
	$Label.text = str(snapped(current_time_goal-time_taken, 0.1))

