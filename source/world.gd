extends Node3D

class_name World

# Passed from Main.
var texture_atlas: ImageTexture
var texture_ids: Dictionary
var atlas_size_in_tiles: Vector2

@onready var voxel_terrain: VoxelTerrain = $VoxelTerrain

func _ready() -> void:
	voxel_terrain.mesher.library.models[1].atlas_size_in_tiles = atlas_size_in_tiles
	voxel_terrain.material_override.albedo_texture = texture_atlas
	voxel_terrain.material_override.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	print(voxel_terrain.mesher.library.models[1])
	print(voxel_terrain.mesher.library.models[1].atlas_size_in_tiles)

# Called from Main once all the data necessary has been passed to this world.
func initialise_world() -> void:
	pass

func _process(delta: float) -> void:
	pass
