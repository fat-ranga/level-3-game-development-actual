extends Resource

class_name Item

# String names compare faster than regular strings.
@export var id: StringName = "default"
@export var name: String = "Default Item"
@export var max_amount: int = 64
@export var icon: CompressedTexture2D = preload("res://data/textures/ui/icons/default.png")
@export var hand_scene: PackedScene

@export var current_amount: int = 1
