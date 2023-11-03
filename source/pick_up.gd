extends RigidBody3D

class_name PickUp

const MAX_LIFETIME: int = 10000
var lifetime = MAX_LIFETIME

@export var slot_data: SlotData

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	sprite_3d.texture = slot_data.item_data.texture

func _physics_process(delta: float) -> void:
	if lifetime < 1:
		queue_free()
		return
	lifetime -= 1
	sprite_3d.rotate_y(delta)
	sprite_3d.position.y += cos(delta * lifetime) * 0.003

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.inventory_data.pick_up_slot_data(slot_data):
		audio_stream_player_3d.play()

func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
