extends Control
signal opened
signal closed

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://Scripts/Inventory/playerInventory.tres")
@onready var ItemStakGuiClass = preload("res://Scenes/Prefabs/itemsStackGui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
	connectSlots()
	inventory.updated.connect(update)
	update()

func connectSlots() -> void:
	for slot in slots:
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStakGuiClass.instantiate()
			slots[i].insert(itemStackGui)
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()

func _open() -> void:
	visible = true
	isOpen = true
	opened.emit()
	
func _close() -> void:
	visible = false
	isOpen = false
	closed.emit()
	
func onSlotClicked(slot) -> void:
	pass
