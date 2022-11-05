extends Node3D

var power_on = false

func click():
	if power_on:
		get_node("Spak/AnimationPlayer").play_backwards("HandtagAction")
	else:
		get_node("Spak/AnimationPlayer").play("HandtagAction")
	power_on = !power_on
