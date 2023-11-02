extends Node

class_name Inventory

signal item_set

@export var width: int = 3
@export var height: int = 3

@export var items: Array[Item] = []

func _ready() -> void:
	# Populate inventory with empty values.
	items.resize(width * height)

func set_item(position: Vector2, item: Item):
	items[int(position.x) * width + int(position.y)] = item
	item_set.emit()

func add_item(item: Item):
	# Iterate through the array until we find a slot occupied by an item
	# of the same type, and increase its amount if the slot isn't greater than its max item stack count.
	for x in range(height):
		for y in range(width):
			if not items[x * width + y]:  # Empty slot, move onto next.
				continue
			if not items[x * width + y].id == item.id: # Not same type, move onto next.
				continue
			# Too many, add extras into new slot.
			if items[x * width + y].current_amount + item.current_amount > item.max_amount:
				item.current_amount -= item.max_amount - items[x * width + y].current_amount
				items[x * width + y].current_amount = item.max_amount
				_make_new_item_in_empty_slot(item)
				item_set.emit()
				return
			# Can add items into same slot.
			if items[x * width + y].current_amount + item.current_amount <= item.max_amount:
				items[x * width + y].current_amount += item.current_amount
				item_set.emit()
				return
	
	# No suitable slots of same type, just try adding it as a new item in a different slot.
	_make_new_item_in_empty_slot(item)

func _make_new_item_in_empty_slot(item: Item) -> void:
	# Find the first empty slot we can find, and add our item to that.
	for x in range(height):
		for y in range(width):
			if not items[x * width + y]:
				set_item(Vector2(x, y), item)
				return
	
	printerr("Can't fit item {item.id} in inventory!")

func get_item(position: Vector2) -> Item:
	return items[int(position.y) * width + int(position.x)]
