extends Node3D

class_name World

signal main_menu_button_pressed

# Passed from Main.
var texture_atlas: ImageTexture
var texture_ids: Dictionary
var atlas_size_in_tiles: Vector2i

@onready var player: Player = $Player
@onready var australian_scene: PackedScene = load("res://scenes/australian.tscn")
@onready var pick_up_scene: PackedScene = load("res://scenes/pick_up.tscn")

@onready var voxel_instancer: VoxelInstancer = $VoxelTerrain/VoxelInstancer
@onready var voxel_terrain: VoxelTerrain = $VoxelTerrain
@onready var voxel_library: VoxelBlockyLibrary = load("res://data/voxel_block_library.tres")

func _ready() -> void:
	player.ui.main_menu_button_pressed.connect(_on_main_menu_button_pressed)
	
	voxel_library.models[1].set_atlas_size_in_tiles(atlas_size_in_tiles)
	
	var mesher: VoxelMesherBlocky = VoxelMesherBlocky.new()
	mesher.library = voxel_library
	voxel_terrain.mesher = mesher
	
	voxel_terrain.material_override.albedo_texture = texture_atlas
	
	var australian: Australian = australian_scene.instantiate()
	australian.position = player.position + Vector3(0, 10, 5)
	add_child(australian)

func _on_main_menu_button_pressed() -> void:
	main_menu_button_pressed.emit()


func _on_player_drop_slot_data(slot_data) -> void:
	var pick_up: PickUp = pick_up_scene.instantiate()
	pick_up.slot_data = slot_data
	pick_up.global_position = player.get_drop_position()
	add_child(pick_up)
