extends MarginContainer

class_name MainMenu

signal start_game

@export var colourblind_correction: ColorRect

@onready var buttons: VBoxContainer = $Buttons
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var singleplayer: Button = $Buttons/Singleplayer
@onready var world_select: VBoxContainer = $WorldSelect
@onready var world_buttons: VBoxContainer = $WorldSelect/Area/MarginContainer/Worlds
@onready var delete_world: MarginContainer = $DeleteWorld

# Buttons pertaining to actions that can only be performed once a world is selected.
@onready var play_selected_world: Button = $WorldSelect/Footer/MarginContainer/Buttons/PlaySelectedWorld
@onready var delete: Button = $WorldSelect/Footer/MarginContainer/Buttons/Delete

# These buttons are the footer buttons.
@onready var world_select_footer_buttons: GridContainer = $WorldSelect/Footer/MarginContainer/Buttons

func _ready() -> void:
	singleplayer.grab_focus()
	
	Settings.settings_updated.connect(_update_settings)
	settings_menu.back_button_pressed.connect(_settings_menu_back)
	
	for world in world_buttons.get_children():
		world.focus_entered.connect(_world_selected)
		world.focus_exited.connect(_world_deselected)
	
	for button in world_select_footer_buttons.get_children():
		button.focus_entered.connect(_world_footer_button_selected)
		button.focus_exited.connect(_world_footer_button_deselected)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# De-select all the worlds.
		for world in world_buttons.get_children():
			world.button_pressed = false
		if delete_world.visible:
			delete_world.hide()
			return
		settings_menu.hide()
		world_select.hide()
		buttons.show()

func _update_settings() -> void:
	colourblind_correction.material.set_shader_parameter("mode", Settings.colourblind_mode)

# MAIN MENU

func _on_singleplayer_pressed() -> void:
	world_select.show()

func _on_settings_pressed() -> void:
	buttons.hide()
	settings_menu.show()

func _settings_menu_back() -> void:
	settings_menu.hide()
	buttons.show()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	play_selected_world.disabled = true
	delete.disabled = true
	# De-select all the worlds.
	for world in world_buttons.get_children():
		world.button_pressed = false
	
	settings_menu.hide()
	world_select.hide()
	buttons.show()

func _world_selected() -> void:
	play_selected_world.disabled = false
	delete.disabled = false

func _world_deselected() -> void:
	# Check if we have any other buttons still selected.
	# If not, disable the options for the world.
	for world in world_buttons.get_children():
		if world.button_pressed:
			play_selected_world.disabled = false
			delete.disabled = false
			return
	
	play_selected_world.disabled = true
	delete.disabled = true

# If 'DeleteWorld' is selected, for example, we want to make
# sure it is not immediately disabled because now no world
# button is selected.
func _world_footer_button_selected() -> void:
	for world in world_buttons.get_children():
		if world.button_pressed:
			play_selected_world.disabled = false
			delete.disabled = false
			return
		
	play_selected_world.disabled = true
	delete.disabled = true

func _world_footer_button_deselected() -> void:
	play_selected_world.disabled = true
	delete.disabled = true

func _on_play_selected_world_pressed() -> void:
	start_game.emit()
	
# This button isn't the actual delete button, it just brings up the delete menu.
func _on_delete_pressed() -> void:
	delete_world.show()


# DELETE MENU

func _on_actually_delete_pressed() -> void:
	print("world deleted")

func _on_cancel_pressed() -> void:
	delete_world.hide()
	for world in world_buttons.get_children():
		if world.button_pressed:
			play_selected_world.disabled = false
			delete.disabled = false
			return
