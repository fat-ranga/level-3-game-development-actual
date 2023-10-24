extends Node3D

class_name World

# Passed from Main.
var texture_atlas: ImageTexture
var texture_ids: Dictionary
var atlas_size_in_tiles: Vector2i

@onready var player: Player = $Player

@onready var voxel_instancer: VoxelInstancer = $VoxelTerrain/VoxelInstancer
@onready var voxel_terrain: VoxelTerrain = $VoxelTerrain
@onready var voxel_library: VoxelBlockyLibrary = load("res://data/voxel_block_library.tres")

func _ready() -> void:
	voxel_library.models[1].set_atlas_size_in_tiles(atlas_size_in_tiles)
	
	var mesher: VoxelMesherBlocky = VoxelMesherBlocky.new()
	mesher.library = voxel_library
	voxel_terrain.mesher = mesher
	
	voxel_terrain.material_override.albedo_texture = texture_atlas
	
	

func _process(delta: float) -> void:
	pass
