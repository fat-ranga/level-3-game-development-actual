extends CanvasLayer

const max_colour: Color = Color(0.306, 0.459, 0.224)
const min_colour: Color = Color(0.722, 0.176, 0.169)

@export var player: Player

@onready var healthbar: TextureProgressBar = %Healthbar
@onready var health_bar_number: Label = %HealthBarNumber
@onready var crosshair: TextureRect = $MarginContainer/Crosshair
@onready var main_inventory: MarginContainer = %MainInventory
@onready var slots_container: VBoxContainer = %SlotsContainer
@onready var toolbar_slots_container: VBoxContainer = %ToolbarSlotsContainer
@onready var darken_background: TextureRect = %DarkenBackground
@onready var toolbar: HBoxContainer = %Toolbar

@onready var slot_icon_scene: PackedScene = preload("res://scenes/ui/slot_icon.tscn")
@onready var item_slot_scene: PackedScene = preload("res://scenes/ui/item_slot.tscn")

var item_slots: Array = []

func _ready() -> void:
	player.update_ui.connect(_update_ui)
	player.inventory_toggled.connect(_inventory_toggled)
	
	player.inventory.item_added.connect(_on_item_added)
	
	_generate_inventory_ui()
	_update_ui()

func _update_ui() -> void:
	healthbar.value = player.health
	health_bar_number.text = str(healthbar.value)
	healthbar.tint_progress = lerp(min_colour, max_colour, (healthbar.value / 100))

func _on_item_added(item: Item, amount: int) -> void:
	print("YO YO YO")
	print(item.icon)
	print(amount)
	print(player.inventory.get_item(Vector2(2, 0.7)))
	
	for y in range(player.inventory.height):
		for x in range(player.inventory.width):
			var item_ref: Item = player.inventory.get_item(Vector2(x, y))
			if not item_ref:
				continue
			
			print("is item")
			
			

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
			new_h_box.add_child(new_slot)
			
	# Generate the INVENTORY toolbar slot, not the one at the bottom of the screen.
	var new_h_box = HBoxContainer.new()
	new_h_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_h_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	toolbar_slots_container.add_child(new_h_box)
	
	for x in range(player.inventory.width):
		var new_slot: Button = item_slot_scene.instantiate()
		new_h_box.add_child(new_slot)
	
	# Generate the main visible toolbar.
	for x in range(player.inventory.width):
		var new_slot: Button = item_slot_scene.instantiate()
		toolbar.add_child(new_slot)
		#var icon: Control = slot_icon_scene.instantiate()
		#new_slot.add_child(icon)
