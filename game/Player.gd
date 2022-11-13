extends CharacterBody3D

@onready var rotation_helper = $Rotation_Helper

var MOUSE_SENSITIVITY = 0.1

@onready var synchronizer = $MultiplayerSynchronizer


const SPEED = 5.0
const JUMP_VELOCITY = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Globals.is_multiplayer and synchronizer.is_multiplayer_authority():
#			if synchronizer.is_multiplayer_authority():
			move_and_slide()
		else:
				move_and_slide()
	
	if global_position.y < -20: # teleports back up
		global_position = Vector3(0, 5, 0)
		velocity = Vector3()

func _enter_tree():
	$CanvasLayer/CenterContainer/hotbar/conveyor/Sprite2D.texture = $hotbar_renders/conveyor.get_texture()
	$CanvasLayer/CenterContainer/hotbar/smelter/Sprite2D.texture = $hotbar_renders/smelter.get_texture()
	$CanvasLayer/CenterContainer/hotbar/constructor/Sprite2D.texture = $hotbar_renders/constructor.get_texture()
	$CanvasLayer/CenterContainer/hotbar/Assembler/Sprite2D.texture = $hotbar_renders/Assembler.get_texture()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#func _enter_tree():
	await get_tree().process_frame
	var synchronizer = $MultiplayerSynchronizer
	print(str(name).to_int())
	$Rotation_Helper/ansikte.hide()
	if Globals.is_multiplayer:
		synchronizer.set_multiplayer_authority(str(name).to_int())
		if synchronizer.is_multiplayer_authority():
			$Rotation_Helper/Camera3d.current = true
		else:
			$Rotation_Helper/ansikte.show()




func _input(event):
	if Globals.is_multiplayer: if not synchronizer.is_multiplayer_authority(): return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x + deg_to_rad(event.relative.y * -MOUSE_SENSITIVITY), -1.5, 1.5)
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
