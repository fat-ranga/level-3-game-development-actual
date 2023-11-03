extends MarginContainer

class_name SettingsMenu

signal back_button_pressed

@onready var ui_scale_h_slider: HSlider = $All/Settings/UIScale/HSlider
@onready var ui_scale_number: Label = $All/Settings/UIScale/Number

func _on_h_slider_value_changed(value: float) -> void:
	ui_scale_number.text = str(value)
	Settings.ui_scale = int(value)

func _on_apply_pressed() -> void:
	Settings.update()

func _on_back_pressed() -> void:
	back_button_pressed.emit()

func _on_option_button_item_selected(index: int) -> void:
	Settings.colourblind_mode = index
