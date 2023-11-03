extends Panel

class_name Slot

signal slot_clicked(index: int, button: int)
signal tooltip_shown(slot_data: SlotData)

var item_data_for_tooltip: ItemData
var tool_tip: Tooltip

@onready var tooltip_scene: PackedScene = preload("res://scenes/ui/tooltip.tscn")
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	item_data_for_tooltip = slot_data.item_data
	texture_rect.texture = item_data.texture
	# TODO tooltip maybe
	
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()


func _on_gui_input(event: InputEvent) -> void:
	# Make sure that either a left or right mouse button was pressed
	# on this slot.
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
				slot_clicked.emit(get_index(), event.button_index)
		


func _on_mouse_entered() -> void:
	tool_tip = tooltip_scene.instantiate()
	add_child(tool_tip)


func _on_mouse_exited() -> void:
	tool_tip.queue_free()
