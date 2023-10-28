extends Node

class_name Inventory

signal item_added(item: Item, amount: int)

@export var width: int = 3
@export var height: int = 3

@export var items: Array[Item] = []

func _ready() -> void:
	# Populate inventory with empty values.
	items.resize(width * height)

func set_item(position: Vector2, item: Item):
	items[int(position.x) * width + int(position.y)] = item

func add_item(item: Item, amount: int = 1):
	
	# Iterate through the array until we find a slot occupied by an item
	# of the same type, and increase its amount if the slot isn't greater than its max item stack count.
	for x in range(height):  # TODO: I should do some thinking as to why it's this way round.
		for y in range(width):
			if items[x * width + y]:  # Make sure an item exists in the slot.
				if items[x * width + y].id == item.id:
					if items[x * width + y].current_amount < item.max_amount:
						items[x * width + y].current_amount += 1
						item_added.emit(item, amount) # toodo temp
						return
	
	print("adding new item instead")
	# Otherwise, iterate through the array until we find a slot that
	# isn't occupied by an item.
	for x in range(height):
		for y in range(width):
			if not items[x * width + y]:
				set_item(Vector2(x, y), item)
				item_added.emit(item, amount) # toodo temp
				return

	print_rich("Can't fit item {item.id} in inventory!")

func get_item(position: Vector2) -> Item:
	return items[int(position.y) * width + int(position.x)]
