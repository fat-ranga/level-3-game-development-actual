extends CanvasLayer

class_name PlayerUI

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
@onready var pc_menu: PCMenu = $PCMenu
@onready var interact_prompt: MarginContainer = $MarginContainer/InteractPrompt


@onready var item_slot_scene: PackedScene = preload("res://scenes/ui/item_slot.tscn")

var main_item_slots: Array[ItemSlot] = []
var toolbar_slots: Array = [ItemSlot]
var currently_held_icon: Icon

func _ready() -> void:
	player.update_ui.connect(_update_ui)
	player.inventory_toggled.connect(_inventory_toggled)
	player.inventory.item_set.connect(_update_grid_icons)
	player.interact_pressed.connect(_on_interact_pressed)
	
	_generate_inventory_ui()
	_update_ui()

func _physics_process(delta: float) -> void:
	if player.is_pc_selectable:
		crosshair.hide()
		interact_prompt.show()
	else:
		interact_prompt.hide()
		crosshair.show()

func _update_ui() -> void:
	healthbar.value = player.health
	health_bar_number.text = str(healthbar.value)
	healthbar.tint_progress = lerp(min_colour, max_colour, (healthbar.value / 100))

func _on_interact_pressed() -> void:
	if interact_prompt.visible:
		get_tree().paused = true
		#get_tree().change_scene_to_file("res://scenes/pc.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.is_in_menu = true
		pc_menu.show()

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
		player.is_in_menu = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.is_in_menu = false
		for i in range(main_item_slots.size()):
			main_item_slots[i].delete_tooltip()

func _generate_inventory_ui() -> void:
	# -1 because the last slot is for the toolbar.
	for y in range(player.inventory.height - 1):
		var new_h_box = HBoxContainer.new()
		new_h_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_h_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slots_container.add_child(new_h_box)
		
		for x in range(player.inventory.width):
			var new_slot: ItemSlot = item_slot_scene.instantiate()
			new_slot._item_icon.player_inventory = player.inventory
			new_slot._item_icon.position_in_inventory = Vector2(x, y)
			main_item_slots.append(new_slot)
			new_h_box.add_child(new_slot)
			
	# Generate the INVENTORY toolbar slot, not the one at the bottom of the screen.
	var new_h_box = HBoxContainer.new()
	new_h_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_h_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	toolbar_slots_container.add_child(new_h_box)
	
	for x in range(player.inventory.width):
		var new_slot: ItemSlot = item_slot_scene.instantiate()
		new_slot._item_icon.player_inventory = player.inventory
		new_slot._item_icon.position_in_inventory = Vector2(x, player.inventory.height)
		main_item_slots.append(new_slot)
		new_h_box.add_child(new_slot)
	
	# Generate the main visible toolbar.
	for x in range(player.inventory.width):
		var new_slot: ItemSlot = item_slot_scene.instantiate()
		new_slot._item_icon.player_inventory = player.inventory
		new_slot._item_icon.position_in_inventory = Vector2(x, player.inventory.height)
		toolbar_slots.append(new_slot)
		toolbar.add_child(new_slot)
		#var icon: Control = slot_icon_scene.instantiate()
		#new_slot.add_child(icon)
