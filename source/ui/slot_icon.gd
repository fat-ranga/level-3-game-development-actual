extends Control

class_name Icon

signal selected # Pass in vector2 position?

# Passed down by player UI.
var player_inventory: Inventory
var position_in_inventory: Vector2

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
	var tooltip_text_fr: String = ""
	var current_item: Item = player_inventory.get_item(position_in_inventory)
	tooltip_text_fr += current_item.name
	
	if current_item.tooltip_text:
		tooltip_text_fr += "\n [color=#6e9aeb]"
		tooltip_text_fr += current_item.tooltip_text
		tooltip_text_fr += "[/color]"
		
	if current_item.damage:
		tooltip_text_fr += "\n Damage: [color=salmon]"
		tooltip_text_fr += str(current_item.damage)
		
	new_tooltip.set_text(tooltip_text_fr)
	add_child(new_tooltip)
	new_tooltip.show()

func _on_mouse_exited() -> void:
	new_tooltip.hide()
	new_tooltip.queue_free()

# TODO
func _on_inventory_closed() -> void:
	new_tooltip.hide()
	new_tooltip.queue_free()

# Mouse has selected the slot.
func _on_focus_entered() -> void:
	pass # Replace with function body.
