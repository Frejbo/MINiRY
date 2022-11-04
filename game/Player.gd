extends CharacterBody3D

@onready var rotation_helper = $Rotation_Helper

var MOUSE_SENSITIVITY = 0.1



const SPEED = 3.0
const JUMP_VELOCITY = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("movement_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: move_and_slide()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x + deg_to_rad(event.relative.y * -MOUSE_SENSITIVITY), -1.5, 1.5)
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
