extends Node3D

class_name World

# Passed from Main.
var texture_atlas: ImageTexture
var texture_ids: Dictionary
var atlas_size_in_tiles: Vector2i

var voxel_terrain_scene: PackedScene = preload("res://scenes/world_voxel_terrain.tscn")
var player_scene: PackedScene = preload("res://scenes/player.tscn")
#@onready var voxel_terrain: VoxelTerrain = $VoxelTerrai
var player: Player
@onready var voxel_instancer: VoxelInstancer = $VoxelInstancer
var voxel_terrain: VoxelTerrain

func _ready() -> void:
	#voxel_terrain.mesher.library.models[1].set_atlas_size_in_tiles(atlas_size_in_tiles)
	#
	#print(voxel_terrain.mesher.library.models[1])
	#print(voxel_terrain.mesher.library.models[1].atlas_size_in_tiles)
	#voxel_terrain.
	voxel_terrain = voxel_terrain_scene.instantiate()
	voxel_terrain.mesher.library.models[1].set_atlas_size_in_tiles(atlas_size_in_tiles)
	voxel_terrain.material_override.albedo_texture = texture_atlas
	voxel_terrain.material_override.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	remove_child(voxel_instancer)
	voxel_terrain.add_child(voxel_instancer)
	add_child(voxel_terrain)
	player = player_scene.instantiate()
	player.position.y = 50
	add_child(player)
	
	

# Called from Main once all the data necessary has been passed to this world.
func initialise_world() -> void:
	pass

func _process(delta: float) -> void:
	pass
