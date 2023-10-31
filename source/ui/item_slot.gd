extends Button

class_name ItemSlot

@export var _item_icon: Icon
@onready var slot_icon_scene: PackedScene = preload("res://scenes/ui/slot_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_item_icon() -> void:
	_item_icon.hide()

func set_item_icon(item_data: Item) -> void:
	_item_icon.set_icon_texture(item_data.icon)
	_item_icon.set_current_amount(item_data.current_amount)
	_item_icon.show()
