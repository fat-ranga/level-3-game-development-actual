extends Node


const WORLD_SCENE_PATH: String = "res://scenes/world.tscn"

var world: World
@onready var main_menu: MainMenu = $MainMenu
@onready var texture_atlas_packer: TextureAtlasPacker = $TextureAtlasPacker

var texture_atlas: ImageTexture

func _ready() -> void:
	main_menu.start_game.connect(_start_game)
	_load_resources()

func _load_resources() -> void:
	texture_atlas = texture_atlas_packer.generate_texture_atlas(Constants.TEXTURE_DIRECTORY)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		Settings.fullscreen_enabled = not Settings.fullscreen_enabled
		if Settings.fullscreen_enabled:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _start_game() -> void:
	var world_scene: PackedScene = load(WORLD_SCENE_PATH)
	world = world_scene.instantiate()
	world.texture_atlas = texture_atlas
	add_child(world)
	main_menu.hide()
