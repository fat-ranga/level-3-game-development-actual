extends Node

const CHUNK_SIZE: int = 32
const TEXTURE_DIRECTORY: String = "res://data/textures/atlas/"
const TEXTURE_SIZE: int = 16
const TEXTURE_ATLAS_SIZE: int = 64 # Only works in multiples of the TEXTURE_SIZE.

@onready var DIRECTORY_LOCAL_EXECUTABLE: String = str(OS.get_executable_path().get_base_dir()) + "/"
