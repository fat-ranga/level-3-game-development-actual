extends Control

class_name Icon

var tooltip_scene: PackedScene = preload("res://scenes/ui/tooltip.tscn")
var new_tooltip: Tooltip

@export var texture_rect: TextureRect
@export var number: Label

func set_icon_texture(icon_texture: CompressedTexture2D) -> void:
	texture_rect.texture = icon_texture

func set_current_amount(amount: int) -> void:
	number.text = str(amount)

func _on_mouse_entered() -> void:
	new_tooltip = tooltip_scene.instantiate()
	add_child(new_tooltip)
	new_tooltip.show()

func _on_mouse_exited() -> void:
	new_tooltip.hide()
	new_tooltip.queue_free()
