extends Node3D

var length = 1 # 1 - 5
const MIDDLE_LENGTH = 0.5

@onready var select_raycast = get_node("/root/main/Player/Rotation_Helper/RayCast3d")
func _input(event):
	if event.is_action_pressed("scroll_down"):
		length = clamp(length+1, 1, 5)
	if event.is_action_pressed("scroll_up"):
		length = clamp(length-1, 1, 5)	
#if not event.is_action_released("select") and !planning:
#		planning = true
#		$Node/conveyorbelt_start.position = select_raycast.get_collision_point()
	
	
#	length += 1
#	$conveyorbelt_end.position.x -= MIDDLE_LENGTH
#	$conveyorbelt_middle.scale.x = length
#	$conveyorbelt_middle.position.x -= MIDDLE_LENGTH/2
#
#	if select_raycast.is_colliding():
#		print(select_raycast.get_collision_point().distance_to($conveyorbelt_start))
