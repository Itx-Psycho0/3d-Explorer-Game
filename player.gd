extends CharacterBody3D

var SPEED  := 5.0
const JUMP_VELOCITY = 4.5
const SPRINT_SPEED = 10.0

# Mouse sensitivity
const MOUSE_SENSITIVITY = 0.002

# Reference to camera
@onready var camera = $Camera3D

func _ready():
	# Capture the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement
	if event is InputEventMouseMotion:
		# Rotate player left/right
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		# Rotate camera up/down
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# Clamp camera rotation to prevent over-rotation
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("ui_shift"):
		SPEED = SPRINT_SPEED
		print("Sprinting")
	else:
		SPEED = 5.0

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()