extends CanvasLayer

class_name PlayerUI

signal main_menu_button_pressed

const max_colour: Color = Color(0.306, 0.459, 0.224) # Green.
const min_colour: Color = Color(0.722, 0.176, 0.169) # Red.

@export var player: Player

@onready var healthbar: TextureProgressBar = %Healthbar
@onready var health_bar_number: Label = %HealthBarNumber
@onready var main_inventory: MarginContainer = %MainInventory
@onready var slots_container: VBoxContainer = %SlotsContainer
@onready var toolbar_slots_container: VBoxContainer = %ToolbarSlotsContainer
@onready var darken_background: TextureRect = %DarkenBackground
@onready var toolbar: HBoxContainer = %Toolbar
@onready var pc_menu: PCMenu = $PCMenu
@onready var death_menu: MarginContainer = $DeathMenu
@onready var main_stuff: MarginContainer = %MainStuff
@onready var tooltip: MarginContainer = %Tooltip
@onready var interact_prompt: MarginContainer = %InteractPrompt
@onready var crosshair: TextureRect = %Crosshair

func _ready() -> void:
	player.update_ui.connect(_update_ui)
	player.inventory_toggled.connect(_inventory_toggled)
	player.interact_pressed.connect(_on_interact_pressed)
	player.died.connect(_on_player_died)
	
	_update_ui()

func _physics_process(delta: float) -> void:
	if player.is_pc_selectable:
		crosshair.hide()
		interact_prompt.show()
	else:
		interact_prompt.hide()
		crosshair.show()

func _update_ui() -> void:
	healthbar.value = player.health
	health_bar_number.text = str(healthbar.value)
	healthbar.tint_progress = lerp(min_colour, max_colour, (healthbar.value / 100))

func _on_player_died() -> void:
	main_stuff.hide()
	death_menu.show()
	player.is_in_menu = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_interact_pressed() -> void:
	if interact_prompt.visible:
		get_tree().paused = true
		#get_tree().change_scene_to_file("res://scenes/pc.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.is_in_menu = true
		pc_menu.show()

func _inventory_toggled() -> void:
	main_inventory.visible = not main_inventory.visible
	darken_background.visible = main_inventory.visible
	crosshair.visible = not main_inventory.visible
	if main_inventory.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.is_in_menu = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.is_in_menu = false
		#for i in range(main_item_slots.size()):
		#	main_item_slots[i].delete_tooltip()

func _on_main_menu_pressed() -> void:
	main_menu_button_pressed.emit()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
