extends Node

signal settings_updated

var fullscreen_enabled: bool = false
var ui_scale: int = 2

# Colourblind mode.
# 0 - Protanopia.
# 1 - Deutranopia.
# 2 - Tritanopia.
# 3 - None (default).
var colourblind_mode: int = 3

func update() -> void:
	settings_updated.emit()
	get_tree().root.content_scale_factor = ui_scale
	
