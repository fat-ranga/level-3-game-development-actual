extends Node3D

class_name World

# Passed from Main.
var texture_atlas: ImageTexture

@onready var voxel_terrain: VoxelTerrain = $VoxelTerrain

func _ready() -> void:
	voxel_terrain.material_override.albedo_texture = texture_atlas
	voxel_terrain.material_override.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

func _process(delta: float) -> void:
	pass
