extends Node

# TODO: return Err instead, just like rust enums au!!!!
func load_mod(path: String) -> Resource:
	# duplicate resource and its dir into exe dir
	
	return load(path)
	
