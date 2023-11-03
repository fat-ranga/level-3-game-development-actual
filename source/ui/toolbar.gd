extends HBoxContainer

class_name Toolbar

const SLOT_SCENE: PackedScene = preload("res://scenes/ui/slot.tscn")

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_toolbar)
	populate_toolbar(inventory_data)

func populate_toolbar(inventory_data: InventoryData) -> void:
	for child in get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas.slice(inventory_data.slot_datas.size() - 9, inventory_data.slot_datas.size()):
		var slot: Slot = SLOT_SCENE.instantiate()
		add_child(slot)
		if slot_data:
			slot.set_slot_data(slot_data)
