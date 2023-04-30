extends Label


@onready var label := text.replace(".", "")
var dots := ""

func _on_dots_timeout():
	text = label + dots
	
	dots += "."
	if dots.length() > 3:
		dots = ""
