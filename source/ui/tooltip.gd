extends MarginContainer

class_name Tooltip

@export var label: RichTextLabel

func set_text(tooltip_text: String) -> void:
	label.text = tooltip_text

func _process(delta: float) -> void:
	global_position = get_viewport().get_mouse_position()
