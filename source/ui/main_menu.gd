extends MarginContainer

class_name MainMenu

signal start_game

@onready var buttons: VBoxContainer = $Buttons
@onready var settings_menu: VBoxContainer = $SettingsMenu
@onready var singleplayer: Button = $Buttons/Singleplayer

func _ready() -> void:
	singleplayer.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		settings_menu.hide()
		buttons.show()

func _on_singleplayer_pressed() -> void:
	start_game.emit()

func _on_settings_pressed() -> void:
	buttons.hide()
	settings_menu.show()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	settings_menu.hide()
	buttons.show()
