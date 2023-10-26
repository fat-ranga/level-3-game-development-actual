extends Node

# todo: rename this autoload
# remove res:// replace with costant exe dir
const mod_load_directories: PackedStringArray = [
	"res://data/textures/atlas/",
	"res://data/textures/ui/",
	"res://data/textures/ui/background.png",
	"res://data/voxel_block_library.tres",
]

# TODO: return Err instead, just like rust enums au!!!!
func load_mod(path: String) -> Resource:
	# duplicate resource and its dir into exe dir
	if path in mod_load_directories:
		print("gangster")
		return load(path)
	else:
		return load(path)
	
