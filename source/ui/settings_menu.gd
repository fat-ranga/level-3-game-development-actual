extends MarginContainer

class_name SettingsMenu

@onready var ui_scale_h_slider: HSlider = $All/Settings/UIScale/HSlider
@onready var ui_scale_number: Label = $All/Settings/UIScale/Number


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	ui_scale_number.text = str(ui_scale_h_slider.value)
