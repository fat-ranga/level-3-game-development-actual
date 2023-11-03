extends Resource

class_name SlotData

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity

func can_merge_with(other_slot_data: SlotData) -> bool:
	if item_data.name != other_slot_data.item_data.name:
		return false
	if quantity >= item_data.max_amount:
		return false
	
	return true
	

func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	if item_data.name != other_slot_data.item_data.name:
		return false
	if quantity + other_slot_data.quantity > item_data.max_amount:
		return false
	
	return true

func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity

func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate(true) # Deep copy so that we don't have AKs sharing the same magazine.
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

func set_quantity(value: int) -> void:
	quantity = value
	if quantity > item_data.max_amount:
		quantity = item_data.max_amount
		push_error(item_data.name + " amount set beyond max amount of "\
		 + str(item_data.max_amount) + ". Setting quantity to " + str(item_data.max_amount) + ".")
