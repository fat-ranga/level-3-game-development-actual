extends CharacterBody3D

class_name Player

const SPEED: float = 10.0
const JUMP_VELOCITY: float = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = -10.0

@onready var camera: Camera3D = $CameraBase/Camera
@onready var camera_base: Node3D = $CameraBase

@onready var initial_camera_base_position: Vector3 = camera_base.position - position

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_base.rotate_y(-event.relative.x * 0.007)
		camera.rotate_x(-event.relative.y * 0.007)
		camera.rotation.x = clamp(camera.rotation.x, -90 * (PI/180), 90 * (PI/180))
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	# TODO: delta time
	camera_base.global_position = global_position + initial_camera_base_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 2

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: Vector3
	
	if Input.is_action_pressed("move_forwards"):
		direction += Vector3(-sin(camera_base.global_rotation.y), 0.0, -cos(camera_base.global_rotation.y))
	if Input.is_action_pressed("move_backwards"):
		direction += Vector3(sin(camera_base.global_rotation.y), 0.0, cos(camera_base.global_rotation.y))
	if Input.is_action_pressed("move_left"):
		direction += -camera_base.basis.x
	if Input.is_action_pressed("move_right"):
		direction += camera_base.basis.x
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	
	
	move_and_slide()

func _ground_move() -> void:
	pass
