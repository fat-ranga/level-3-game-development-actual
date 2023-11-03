extends Button

class_name ItemSlot

signal icon_pressed(icon: Icon)

var position_in_inventory: Vector2i

@export var _item_icon: Icon
@onready var slot_icon_scene: PackedScene = preload("res://scenes/ui/slot_icon.tscn")

func _ready() -> void:
	_item_icon.pressed.connect(_on_icon_pressed)

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

func _on_icon_pressed() -> void:
	icon_pressed.emit(_item_icon)
