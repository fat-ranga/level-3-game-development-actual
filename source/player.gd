extends CharacterBody3D

class_name Player

signal update_ui
signal inventory_toggled

const SPEED: float = 10.0
const JUMP_VELOCITY: float = 9.0
const GRAVITY: float = -14.0

var health: int = 100

@onready var camera: Camera3D = $CameraBase/Camera
@onready var camera_base: Node3D = $CameraBase
@onready var initial_camera_base_position: Vector3 = camera_base.position - position
@onready var arms_base: Node3D = $CameraBase/Camera/ArmsBase
@export var inventory: Inventory


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	inventory.add_item(ItemDatabase.item["7.62x39"])
	print(inventory.items[0].damage)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_base.rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -90 * (PI/180), 90 * (PI/180))
		
		# Arm drag.
		arms_base.position.x += -event.relative.x * 0.002
		arms_base.position.y += event.relative.y * 0.002
		
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("ui_home"):
		damage(7)
		
	if event.is_action_pressed("toggle_inventory"):
		inventory_toggled.emit()

func _process(delta: float) -> void:
	# TODO: delta time with previous pos and rot and lerp + slerp???
	# Camera transforms are independent of the player. Done this way so that we
	# don't rotate the collision shape, and perhaps also to have interpolation.
	camera_base.global_position = global_position + initial_camera_base_position
	arms_base.position = lerp(arms_base.position, Vector3(0.0, 0.0, 0.0), delta * 15.0)
	
	if Input.is_action_pressed("aim"):
		camera.fov = lerp(camera.fov, 50.0, delta * 15.0)
	else:
		camera.fov = lerp(camera.fov, 90.0, delta * 15.0)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
			velocity.y += GRAVITY * delta * 2

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

func damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()
	update_ui.emit()

func _die():
	print("nahh dead au!")
