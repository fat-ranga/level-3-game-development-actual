extends Node

@onready var _item_data_base_to_load: ItemDatabaseResource = preload("res://data/items/ammunition.tres")
@onready var _actual_item_database: Array = _item_data_base_to_load.item_database

# This is where item types are accessed from for the whole game.
var item: Dictionary = {}

func _ready() -> void:
	generate_item_data_base_dictionary()

# Bullshit function because Godot still hasn't added typed dictionaries.
# Should've all been 100% statically typed from the start. Dynamic typing
# is the worst thing to happen to programming, in my humble opinion.
func generate_item_data_base_dictionary() -> void:
	for i in range(_actual_item_database.size()):
		item[_actual_item_database[i].id] = _actual_item_database[i]
		print(_actual_item_database[i].id)
