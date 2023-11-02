extends Button

class_name ItemSlot

@export var _item_icon: Icon
@onready var slot_icon_scene: PackedScene = preload("res://scenes/ui/slot_icon.tscn")

func remove_item_icon() -> void:
	_item_icon.hide()

func set_item_icon(item_data: Item) -> void:
	_item_icon.set_icon_texture(item_data.icon)
	_item_icon.set_current_amount(item_data.current_amount)
	_item_icon.show()

# Used for when the inventory is closed.
func delete_tooltip() -> void:
	if _item_icon != null and _item_icon.new_tooltip != null:
		_item_icon.new_tooltip.hide()
		_item_icon.new_tooltip.queue_free()
