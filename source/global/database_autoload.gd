extends Node

@onready var item_data_dir: String = "res://data/items/"
#@onready var _item_data_base_to_load: DatabaseResource = preload("res://data/items/ammunition.tres")
#@onready var item_database: Array = _item_data_base_to_load.item_database
#@onready var recipe_database: Array = _item_data_base_to_load.recipe_database

# This is where item types and recipes are accessed from for the whole game.
var item: Dictionary = {}
var recipe: Dictionary = {}

func _ready() -> void:
	pass
	#load_items()
	#load_recipes()

#func new_item(id: StringName) -> Item:
#	# Make a deep copy of the resource, so that subresources such as magazines in AKs are not shared.
#	return item[id].duplicate(true)
#
## Startup function to add all our stuff to a dictionary to make things accessible from elsewhere.
#func generate_item_data_base_dictionary(item_database: Array[Item]) -> void:
#	for i in range(item_database.size()):
#		if item_database[i] == null:
#			return
#		item[item_database[i].id] = item_database[i]
#
#func generate_recipe_data_base_dictionary(recipe_database: Array[Recipe]) -> void:
#	for i in range(recipe_database.size()):
#		if recipe_database[i] == null:
#			return
#		recipe[recipe_database[i].id] = recipe_database[i]
#
#func load_databases() -> void:
#	var paths: PackedStringArray = _get_file_paths_in_directory(item_data_dir)
#
#	for path in paths:
#		var database: DatabaseResource = load(path)
#
#		generate_item_data_base_dictionary(database.item_database)
#		generate_recipe_data_base_dictionary(database.recipe_database)
#





func _get_file_paths_in_directory(root_directory: String) -> PackedStringArray:
	var files: PackedStringArray = []
	var directories: PackedStringArray = []
	var dir = DirAccess.open(root_directory)
	
	dir.list_dir_begin()
	_add_dir_contents(dir, files, directories)

	return files

func _add_dir_contents(dir: DirAccess, files: PackedStringArray, directories: PackedStringArray):
	var file_name = dir.get_next()
	
	# If there's no file, the while loop ends.
	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		
		# Checks whether the current path is a folder or a file.
		if dir.current_is_dir():
			print("Database Loader : Found directory: %s" % path)
			var subDir = DirAccess.open(path)
			subDir.list_dir_begin()
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			print("Database Loader : Found file: %s" % path)
			files.append(path)
		
		# Get the next file in the directory.
		file_name = dir.get_next()
	
	dir.list_dir_end()
