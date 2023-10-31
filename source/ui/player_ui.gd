extends CanvasLayer

const max_colour: Color = Color(0.306, 0.459, 0.224) # Green.
const min_colour: Color = Color(0.722, 0.176, 0.169) # Red.

@export var player: Player

@onready var healthbar: TextureProgressBar = %Healthbar
@onready var health_bar_number: Label = %HealthBarNumber
@onready var crosshair: TextureRect = $MarginContainer/Crosshair
@onready var main_inventory: MarginContainer = %MainInventory
@onready var slots_container: VBoxContainer = %SlotsContainer
@onready var toolbar_slots_container: VBoxContainer = %ToolbarSlotsContainer
@onready var darken_background: TextureRect = %DarkenBackground
@onready var toolbar: HBoxContainer = %Toolbar

@onready var item_slot_scene: PackedScene = preload("res://scenes/ui/item_slot.tscn")

var main_item_slots: Array[ItemSlot] = []
var toolbar_slots: Array = [ItemSlot]

func _ready() -> void:
	player.update_ui.connect(_update_ui)
	player.inventory_toggled.connect(_inventory_toggled)
	player.inventory.item_set.connect(_update_grid_icons)
	
	_generate_inventory_ui()
	_update_ui()

func _update_ui() -> void:
	healthbar.value = player.health
	health_bar_number.text = str(healthbar.value)
	healthbar.tint_progress = lerp(min_colour, max_colour, (healthbar.value / 100))

func _update_grid_icons() -> void:
	# First, delete all icons we currently have.
	for i in range(main_item_slots.size()):
		main_item_slots[i].remove_item_icon()
	
	# Loop through and add icons to each slot based on item
	# type and number.
	for i in range(main_item_slots.size()):
		var item_ref: Item = player.inventory.items[i]
		
		# If there is no item in the slot, remove the icon and leave the slot blank.
		if not item_ref:
			main_item_slots[i].remove_item_icon()
			continue
		
		main_item_slots[i].set_item_icon(item_ref)

func _inventory_toggled() -> void:
	main_inventory.visible = not main_inventory.visible
	darken_background.visible = main_inventory.visible
	crosshair.visible = not main_inventory.visible
	if main_inventory.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _generate_inventory_ui() -> void:
	print(player.inventory)
	
	# -1 because the last slot is for the toolbar.
	for y in range(player.inventory.height - 1):
		var new_h_box = HBoxContainer.new()
		new_h_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_h_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slots_container.add_child(new_h_box)
		
		for x in range(player.inventory.width):
			var new_slot: Button = item_slot_scene.instantiate()
			main_item_slots.append(new_slot)
			new_h_box.add_child(new_slot)
			
	# Generate the INVENTORY toolbar slot, not the one at the bottom of the screen.
	var new_h_box = HBoxContainer.new()
	new_h_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_h_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	toolbar_slots_container.add_child(new_h_box)
	
	for x in range(player.inventory.width):
		var new_slot: Button = item_slot_scene.instantiate()
		main_item_slots.append(new_slot)
		new_h_box.add_child(new_slot)
	
	# Generate the main visible toolbar.
	for x in range(player.inventory.width):
		var new_slot: Button = item_slot_scene.instantiate()
		toolbar_slots.append(new_slot)
		toolbar.add_child(new_slot)
		#var icon: Control = slot_icon_scene.instantiate()
		#new_slot.add_child(icon)
