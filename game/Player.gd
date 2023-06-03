extends CharacterBody3D

@onready var rotation_helper := $Rotation_Helper

var MOUSE_SENSITIVITY := 0.1
var JOYSTICK_SENSITIVITY := 2

# moving
@export var MAX_SPEED := 5.0
@export var MAX_SPRINT_SPEED := 10.0
var speed = MAX_SPEED
@export var ACCELERATION := .1
@export var DEACCELERATION := 0.5
# jumping
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _physics_process(delta) -> void:
	stick_looking()
	
	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		var y := velocity.y
		velocity.y = 0
		velocity += (direction * (ACCELERATION * speed))
		velocity = velocity.limit_length(speed)
		velocity.y = y
		velocity = velocity.normalized() * velocity.length()
	else:
		# slowing down after key is released
		velocity.x *= DEACCELERATION
		velocity.z *= DEACCELERATION
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: # only move if mouse mode captured.
		move_and_slide()
	
	if global_position.y < -20: # teleports back up if player falls out of map for some reason
		global_position = Vector3(0, 5, 0)
		velocity = Vector3.ZERO

func _ready():
	$CanvasLayer/CenterContainer/hotbar/conveyor/Sprite2D.texture = $hotbar_renders/conveyor.get_texture()
	$CanvasLayer/CenterContainer/hotbar/smelter/Sprite2D.texture = $hotbar_renders/smelter.get_texture()
	$CanvasLayer/CenterContainer/hotbar/constructor/Sprite2D.texture = $hotbar_renders/constructor.get_texture()
	$CanvasLayer/CenterContainer/hotbar/Assembler/Sprite2D.texture = $hotbar_renders/Assembler.get_texture()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event) -> void:
	# rotate the character as the player moves the mouse
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion: # Mouse steering
			rotation_helper.rotation.x = clamp(rotation_helper.rotation.x + deg_to_rad(event.relative.y * -MOUSE_SENSITIVITY), -1.5, 1.5)
			self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
	
	if Input.is_action_just_pressed("sprint"):
		speed = MAX_SPRINT_SPEED
	elif Input.is_action_just_released("sprint"):
		speed = MAX_SPEED
	elif event is InputEventJoypadMotion and event.axis == 5:
		speed = MAX_SPEED + ((MAX_SPRINT_SPEED - MAX_SPEED) * event.axis_value)
	
	# Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func stick_looking():
	var vec := Input.get_vector("look_left", "look_right", "look_down", "look_up")
	rotation_helper.rotation.x = clamp(rotation_helper.rotation.x + deg_to_rad(vec.y * JOYSTICK_SENSITIVITY), -1.5, 1.5)
	self.rotate_y(deg_to_rad(vec.x * JOYSTICK_SENSITIVITY * -1))
