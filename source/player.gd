extends CharacterBody3D

class_name Player

signal update_ui
signal inventory_toggled
signal interact_pressed
signal died
signal drop_slot_data(slot_data: SlotData)

const SPEED: float = 3.0
const JUMP_VELOCITY: float = 9.0
const GRAVITY: float = -14.0

var health: int = 100
var is_in_menu: bool = false
var is_pc_selectable: bool = false

@export var raycast: RayCast3D
@export var inventory_data: InventoryData
@export var inventory_interface: InventoryInterface

@onready var camera: Camera3D = $CameraBase/Camera
@onready var camera_base: Node3D = $CameraBase
@onready var initial_camera_base_position: Vector3 = camera_base.position - position
@onready var arms_base: Node3D = $CameraBase/Camera/ArmsBase
@onready var ui: CanvasLayer = $UI
@onready var animation_player: AnimationPlayer = $CameraBase/Camera/ArmsBase/fps_arms/AnimationPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory_interface.set_player_inventory_data(inventory_data)
	inventory_interface.set_toolbar_inventory_data(inventory_data)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory_toggled.emit()
		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("ui_home"):
		damage(7)
	if event.is_action_pressed("interact"):
		interact_pressed.emit()
	
		
	if is_in_menu:
		return
	if event is InputEventMouseMotion:
		camera_base.rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -90 * (PI/180), 90 * (PI/180))
		
		# Arm drag.
		arms_base.position.x += -event.relative.x * 0.002
		arms_base.position.y += event.relative.y * 0.002

		

func _process(delta: float) -> void:
	# TODO: delta time with previous pos and rot and lerp + slerp???
	# Camera transforms are independent of the player. Done this way so that we
	# don't rotate the collision shape, and perhaps also to have interpolation.
	camera_base.global_position = global_position + initial_camera_base_position
	arms_base.position = lerp(arms_base.position, Vector3(0.0, 0.0, 0.0), delta * 15.0)
	
	if Input.is_action_pressed("aim") and not is_in_menu:
		camera.fov = lerp(camera.fov, 50.0, delta * 15.0)
	else:
		camera.fov = lerp(camera.fov, 90.0, delta * 15.0)
	
	if Input.is_action_pressed("fire") and not is_in_menu:
		animation_player.play("punch")
		var hit = raycast.get_collider()
		if hit:
			if hit.is_in_group("enemy"):
				hit.damage(randi_range(19, 38))
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta * 2
	else:
		velocity.y = -0.2
	
	if is_in_menu:
		velocity.x *= 0.7
		velocity.z *= 0.7
		velocity.y = clamp(velocity.y, -30, 500)
		move_and_slide()
		return
	
	var collider: Object = raycast.get_collider()
	if collider:
		if collider.is_in_group("PC"):
			is_pc_selectable = true
		else:
			is_pc_selectable = false
	else:
		is_pc_selectable = false
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_forwards"):
		direction += Vector3(-sin(camera_base.global_rotation.y), 0.0, -cos(camera_base.global_rotation.y))
	if Input.is_action_pressed("move_backwards"):
		direction += Vector3(sin(camera_base.global_rotation.y), 0.0, cos(camera_base.global_rotation.y))
	if Input.is_action_pressed("move_left"):
		direction += -camera_base.basis.x
	if Input.is_action_pressed("move_right"):
		direction += camera_base.basis.x
	
	velocity.x += direction.x * SPEED
	velocity.z += direction.z * SPEED
	
	velocity.x *= 0.7
	velocity.z *= 0.7
	
	velocity.y = clamp(velocity.y, -30, 500)
	
	move_and_slide()

func _ground_move() -> void:
	pass

func damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()
	update_ui.emit()

func _die():
	died.emit()


func _on_inventory_interface_drop_slot_data(slot_data) -> void:
	drop_slot_data.emit(slot_data)

func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play("idle")
