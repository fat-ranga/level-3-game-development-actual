extends Resource

class_name ItemData

@export var name: String = "Default Item"
@export var max_amount: int = 64
@export var texture: CompressedTexture2D = preload("res://data/textures/ui/icons/default.png")
@export var hand_scene: PackedScene = preload("res://scenes/player_arms/default.tscn")
@export_multiline var description: String = ""
