extends CharacterBody3D

@onready var rotation_helper := $Rotation_Helper

var MOUSE_SENSITIVITY := 0.1


@export var MAX_SPEED := 6.0
@export var ACCELERATION := .1
@export var DE_ACCELERATION := 0.5
@export var JUMP_VELOCITY := 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# slow down, gets overriden below if moving.
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var y := velocity.y
		velocity += (direction * (ACCELERATION * MAX_SPEED))
		velocity = velocity.normalized() * velocity.length()
		
#		print(velocity.y)
		velocity = velocity.limit_length(MAX_SPEED)
#		print(velocity.y)
#		print("--")
		velocity.y = y
	else:
		velocity.x *= DE_ACCELERATION
		velocity.z *= DE_ACCELERATION
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: # only move if mouse mode captured.
		move_and_slide()
	
	
	if global_position.y < -20: # teleports back up
		global_position = Vector3(0, 5, 0)
		velocity = Vector3.ZERO

func _ready():
	$CanvasLayer/CenterContainer/hotbar/conveyor/Sprite2D.texture = $hotbar_renders/conveyor.get_texture()
	$CanvasLayer/CenterContainer/hotbar/smelter/Sprite2D.texture = $hotbar_renders/smelter.get_texture()
	$CanvasLayer/CenterContainer/hotbar/constructor/Sprite2D.texture = $hotbar_renders/constructor.get_texture()
	$CanvasLayer/CenterContainer/hotbar/Assembler/Sprite2D.texture = $hotbar_renders/Assembler.get_texture()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	# rotate the character as the player moves the mouse
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x + deg_to_rad(event.relative.y * -MOUSE_SENSITIVITY), -1.5, 1.5)
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
